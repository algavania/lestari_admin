import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/animals/animals_repository.dart';
import 'package:lestari_admin/app/ui/animal_form/animal_added_page.dart';
import 'package:lestari_admin/data/models/animal_model.dart';
import 'package:lestari_admin/widgets/custom_text_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';

class AnimalFormPage extends StatefulWidget {
  final AnimalModel? animalModel;

  const AnimalFormPage({Key? key, this.animalModel}) : super(key: key);

  @override
  State<AnimalFormPage> createState() => _AnimalFormPageState();
}

class _AnimalFormPageState extends State<AnimalFormPage> {
  final List<String> _classificationValues = <String>[
    'Pilih',
    'Pisces',
    'Amphibia',
    'Reptilia',
    'Aves',
    'Mamalia'
  ];
  final List<String> _voreValues = <String>[
    'Pilih',
    'Karnivora',
    'Herbivora',
    'Omnivora'
  ];
  final List<String> _statusValues = <String>[
    'Pilih',
    'Punah (EX)',
    'Punah Alam Liar (EW)',
    'Kritis (CR)',
    'Terancam Punah (EN)',
    'Rentan (VU)',
    'Hampir Terancam (NT)',
    'Risiko Rendah (LC)',
    'Informasi Kurang (DD)',
    'Belum Evaluasi (NE)'
  ];
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _scientificNameController = TextEditingController();
  final TextEditingController _habitatController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _lengthController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _causeController = TextEditingController();
  final TextEditingController _preventionController = TextEditingController();
  final TextEditingController _modelController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<XFile> _images = [];
  String _selectedClassification = 'Pilih';
  String _selectedVore = 'Pilih';
  String _selectedStatus = 'Pilih';
  List<String> _imageUrls = [];
  late AnimalModel _animalModel;

  @override
  void initState() {
    super.initState();

    if (widget.animalModel != null) _setCurrentInfo();
  }

  Future<void> _pickImages() async {
    try {
      final List<XFile> pickedFileList = await _picker.pickMultiImage();
      if (pickedFileList.length > 5) {
        SharedCode.showSnackBar(context, false, 'Gambar maksimal 5');
      } else {
        setState(() {
          _images = pickedFileList;
          _imageUrls = [];
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(
          widget.animalModel == null ? 'Tambah Hewan Baru' : 'Ubah Info Hewan'),
      body: SingleChildScrollView(
        padding: SharedCode.defaultPagePadding,
        child: _buildForm(),
      ),
      bottomNavigationBar: _buildBottomWidget(),
    );
  }

  void _setCurrentInfo() {
    _nameController.text = widget.animalModel?.name ?? '';
    _scientificNameController.text = widget.animalModel?.scientificName ?? '';
    _habitatController.text = widget.animalModel?.habitat ?? '';
    _locationController.text = widget.animalModel?.location ?? '';
    _lengthController.text = widget.animalModel?.length ?? '';
    _weightController.text = widget.animalModel?.weight ?? '';
    _descriptionController.text = widget.animalModel?.description ?? '';
    _causeController.text = widget.animalModel?.cause ?? '';
    _preventionController.text = widget.animalModel?.prevention ?? '';
    _imageUrls = widget.animalModel?.imageUrls ?? [];
    _selectedClassification = widget.animalModel?.classification ?? 'Pilih';
    _selectedVore = widget.animalModel?.vore ?? 'Pilih';
    _selectedStatus = widget.animalModel?.conservationStatus ?? 'Pilih';
    _modelController.text = widget.animalModel?.modelUrl ?? '';
  }

  Widget _buildForm() {
    return Form(key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildTextField('Nama Hewan', _nameController, hintText: 'Komodo'),
          const SizedBox(height: 15.0),
          _buildImageField(),
          const SizedBox(height: 15.0),
          _buildDropdownField('Klasifikasi'),
          const SizedBox(height: 15.0),
          _buildDropdownField('Vora'),
          const SizedBox(height: 15.0),
          _buildDropdownField('Status Konservasi'),
          const SizedBox(height: 15.0),
          _buildTextField('Nama Ilmiah', _scientificNameController,
              hintText: 'Varanus komodoensis'),
          const SizedBox(height: 15.0),
          _buildTextField(
              'Habitat', _habitatController, hintText: 'Hutan hujan tropis'),
          const SizedBox(height: 15.0),
          _buildTextField(
              'Lokasi', _locationController, hintText: 'Pulau Komodo, NTT'),
          const SizedBox(height: 15.0),
          _buildTextField('Berat Hewan dalam kilogram', _weightController,
              hintText: '91 - 140 kg'),
          const SizedBox(height: 15.0),
          _buildTextField('Panjang Hewan dalam centimeter', _lengthController,
              hintText: '198 - 250 cm'),
          const SizedBox(height: 15.0),
          _buildTextField(
              'Deskripsi Singkat', _descriptionController, isMultiline: true,
              hintText: 'Komodo merupakan ...'),
          const SizedBox(height: 15.0),
          _buildTextField(
              'Penyebab Kepunahan', _causeController, isMultiline: true,
              hintText: '1. ...\n2. ...\n3. ...'),
          const SizedBox(height: 15.0),
          _buildTextField('Upaya Pencegahan Kepunahan', _preventionController,
              isMultiline: true, hintText: '1. ...\n2. ...\n3. ...'),
          const SizedBox(height: 15.0),
          // _buildModelField(),
          _buildModelUrlField(),
        ]));
  }

  Widget _buildDropdownField(String title) {
    String selectedValue = 'Value';
    List<String> values = [];

    switch (title) {
      case 'Klasifikasi':
        selectedValue = _selectedClassification;
        values = _classificationValues;
        break;
      case 'Vora':
        selectedValue = _selectedVore;
        values = _voreValues;
        break;
      case 'Status Konservasi':
        selectedValue = _selectedStatus;
        values = _statusValues;
        break;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$title*',
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5.0),
        InputDecorator(
          decoration: InputDecoration(
              isDense: true,
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 12.0, horizontal: 10.0),
              enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: ColorValues.lightGrey),
                  borderRadius: BorderRadius.circular(7.0))
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                style: GoogleFonts.poppins(fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: ColorValues.onyx),
                value: selectedValue,
                isDense: true,
                isExpanded: true,
                icon: const Icon(Icons.arrow_drop_down_rounded, size: 20.0),
                onChanged: (String? value) {
                  setState(() {
                    switch (title) {
                      case 'Klasifikasi':
                        _selectedClassification = value!;
                        break;
                      case 'Vora':
                        _selectedVore = value!;
                        break;
                      case 'Status Konservasi':
                        _selectedStatus = value!;
                        break;
                    }
                  });
                },
                items: values.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool isMultiline = false, String? hintText}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '$labelText*',
        style: GoogleFonts.poppins(
            fontSize: 14, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 5.0),
      CustomTextField(
          isRequired: true,
          controller: controller,
          minLines: isMultiline ? 5 : 1,
          maxLines: isMultiline ? 10 : 1,
          maxLength: isMultiline ? 1000 : null,
          hintText: hintText
      ),
    ]);
  }

  Widget _buildModelUrlField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'URL Model 3D',
          style: GoogleFonts.poppins(
              fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 15.0),
        CustomTextField(
          controller: _modelController,
        )
      ],
    );
  }

  Widget _buildImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Poster atau Gambar Kampanye*',
          style:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5.0),
        SizedBox(
          height: 20.w,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (_, i) {
              return (i == 0)
                  ? InkWell(
                onTap: () {
                  _pickImages();
                },
                child: Container(
                  width: 20.w,
                  height: 20.w,
                  decoration: BoxDecoration(
                      border: Border.all(
                          style: BorderStyle.solid,
                          width: 1.0,
                          color: ColorValues.grey.withOpacity(0.75)),
                      borderRadius: BorderRadius.circular(10.0)),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.file_upload_outlined,
                            color: ColorValues.grey.withOpacity(0.75)),
                        const SizedBox(height: 1.0),
                        Text('Unggah',
                            style: GoogleFonts.poppins(
                                fontSize: 12,
                                color: ColorValues.grey.withOpacity(0.75),
                                fontWeight: FontWeight.w500))
                      ]),
                ),
              )
                  : SizedBox(
                width: 20.w,
                height: 20.w,
                child: Stack(
                  children: [
                    _images.isEmpty && _imageUrls.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: CachedNetworkImage(imageUrl: 
                          _imageUrls[i - 1],
                          fit: BoxFit.cover,
                          width: 20.w,
                          height: 20.w,
                        ))
                    : ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.file(
                          File(_images[i - 1].path),
                          fit: BoxFit.cover,
                          width: 20.w,
                          height: 20.w,
                        )),
                    Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              _images.isEmpty && _imageUrls.isNotEmpty ? _imageUrls.removeAt(i - 1) : _images.removeAt(i - 1);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.all(3.0),
                            padding: const EdgeInsets.all(3.0),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20.0),
                                color: Colors.red),
                            child: const Icon(Icons.delete,
                                color: Colors.white, size: 12.0),
                          ),
                        )),
                  ],
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(width: 10.0),
            itemCount: _images.isEmpty && _imageUrls.isNotEmpty ? _imageUrls.length + 1 : _images.length + 1,
          ),
        ),
      ],
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(
            Icons.arrow_back_ios, size: 20.0, color: ColorValues.grey),
      ),
      elevation: 0,
    );
  }

  Widget _buildBottomWidget() {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        ),
      ]),
      child: ElevatedButton(
        onPressed: () {
          if ((_formKey.currentState?.validate() ?? false) &&
              (_images.isNotEmpty || _imageUrls.isNotEmpty) && _selectedClassification != 'Pilih' &&
              _selectedVore != 'Pilih' && _selectedStatus != 'Pilih') {
            _uploadToFirebase();
          } else {
            SharedCode.showSnackBar(context, false, 'Field tidak boleh kosong');
          }
        },
        child: Text(
            widget.animalModel == null ? 'Tambah Hewan' : 'Perbarui Info'),
      ),
    );
  }

  Future<void> _uploadToFirebase() async {
    context.loaderOverlay.show();
    bool isEdit = widget.animalModel != null;
    try {
      _animalModel = AnimalModel(id: '',
          name: _nameController.text,
          modelUrl: _modelController.text.trimLeft().trimRight(),
          conservationStatus: _selectedStatus,
          vore: _selectedVore,
          classification: _selectedClassification,
          scientificName: _scientificNameController.text,
          habitat: _habitatController.text,
          location: _locationController.text,
          weight: _weightController.text,
          length: _lengthController.text,
          description: _descriptionController.text,
          cause: _causeController.text,
          prevention: _preventionController.text,
          imageUrls: _imageUrls,
          updatedAt: DateTime.now());

      if (isEdit) {
        _animalModel.id = widget.animalModel!.id;
        if (_images.isNotEmpty) {
          for (String url in widget.animalModel!.imageUrls) {
            await FirebaseStorage.instance.refFromURL(url).delete();
          }
        }
        await AnimalsRepository().updateAnimal(_animalModel);
      } else {
        DocumentReference reference = await AnimalsRepository().addAnimal(_animalModel);
        _animalModel.id = reference.id;
      }

      if (_images.isNotEmpty) {
        List<String> urls = [];
        for (var image in _images) {
          TaskSnapshot snapshot = await _uploadImage(_animalModel.id, image);
          String url = await snapshot.ref.getDownloadURL();
          urls.add(url);
        }
        _animalModel.imageUrls = urls;

        await AnimalsRepository().updateAnimal(_animalModel);
      }

      Future.delayed(Duration.zero, () {
        context.loaderOverlay.hide();
        SharedCode.navigatorReplace(context, AnimalAddedPage(isEdit: isEdit));
      });
    } catch (e) {
      SharedCode.showSnackBar(context, false, e.toString());
    }
    context.loaderOverlay.hide();
  }

  Future<TaskSnapshot> _uploadImage(String id, XFile? image) async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('animals/$id/${DateTime.now().toIso8601String()}.png');
    UploadTask uploadTask = firebaseStorageRef.putFile(File(image!.path));
    TaskSnapshot taskSnapshot = await uploadTask;
    return taskSnapshot;
  }
}
