import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/articles/articles_repository.dart';
import 'package:lestari_admin/app/ui/article_form/article_added_page.dart';
import 'package:lestari_admin/data/models/article_model.dart';
import 'package:lestari_admin/widgets/custom_text_field.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ArticleFormPage extends StatefulWidget {
  final ArticleModel? articleModel;

  const ArticleFormPage({Key? key, this.articleModel}) : super(key: key);

  @override
  State<ArticleFormPage> createState() => _ArticleFormPageState();
}

class _ArticleFormPageState extends State<ArticleFormPage> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  XFile _thumbnail = XFile('');
  String _thumbnailUrl = '';
  late ArticleModel _articleModel;
  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.articleModel != null) _setCurrentInfo();
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
          source: ImageSource.gallery);
      setState(() {
        _thumbnailUrl = '';
        _thumbnail = pickedFile!;
      });
    } catch (e) {
      print(e.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(widget.articleModel == null
          ? 'Unggah Artikel Baru'
          : 'Ubah Konten Artikel'),
      body: SingleChildScrollView(
        padding: SharedCode.defaultPagePadding,
        child: _buildForm(),
      ),
      bottomNavigationBar: _buildBottomWidget(),
    );
  }

  void _setCurrentInfo() {
    _titleController.text = widget.articleModel?.title ?? '';
    _contentController.text = widget.articleModel?.description ?? '';
    _thumbnailUrl = widget.articleModel?.imageUrl ?? '';
  }

  Widget _buildForm() {
    return Form(
        key: _formKey,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _buildTextField('Judul', _titleController),
          const SizedBox(height: 15.0),
          _buildImageField(),
          const SizedBox(height: 15.0),
          _buildTextField('Konten', _contentController,
              isMultiline: true),
        ]));
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool isMultiline = false, String? hintText}) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        '$labelText*',
        style:
        GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      const SizedBox(height: 5.0),
      CustomTextField(
          isRequired: true,
          controller: controller,
          minLines: isMultiline ? 8 : 1,
          maxLines: isMultiline ? 15 : 1,
          maxLength: isMultiline ? 2500 : null,
          hintText: hintText),
    ]);
  }

  Widget _buildImageField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thumbnail*',
          style:
          GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 5.0),
        if (_thumbnail.path == '' && _thumbnailUrl != '') SizedBox(
          width: 100.w,
          height: 20.h,
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: CachedNetworkImage(imageUrl: 
                      _thumbnailUrl, width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover)),
              Align(
                  alignment: Alignment.topRight,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _thumbnailUrl = '';
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.red),
                      child: const Icon(Icons.delete,
                          color: Colors.white, size: 20.0),
                    ),
                  )),
            ],
          ),
        ),
        if (_thumbnail.path == '' && _thumbnailUrl == '') InkWell(
          onTap: _pickImage,
          child: Container(
            width: 100.w,
            height: 20.h,
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
        ),
        if (_thumbnail.path != '') SizedBox(
          width: 100.w,
          height: 20.h,
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.file(File(_thumbnail.path), width: 100.w,
                      height: 100.h,
                      fit: BoxFit.cover)),
              Align(
                  alignment: Alignment.topRight,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _thumbnail = XFile('');
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.all(10.0),
                      padding: const EdgeInsets.all(5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Colors.red),
                      child: const Icon(Icons.delete,
                          color: Colors.white, size: 20.0),
                    ),
                  )),
            ],
          ),
        )
      ],
    );
  }

  AppBar _buildAppBar(String title) {
    return AppBar(
      title: Text(title),
      automaticallyImplyLeading: false,
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios,
            size: 20.0, color: ColorValues.grey),
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
              _thumbnail.path != '') {
            _uploadToFirebase();
          } else {
            SharedCode.showSnackBar(context, false, 'Field tidak boleh kosong');
          }
        },
        child:
        Text(widget.articleModel == null
            ? 'Unggah Artikel'
            : 'Perbarui Artikel'),
      ),
    );
  }

  Future<TaskSnapshot> _uploadImage(String id, XFile? image) async {
    Reference firebaseStorageRef = FirebaseStorage.instance
        .ref()
        .child('articles/$id/thumbnail.png');
    late UploadTask uploadTask;
    if (kIsWeb) {
      var bytes = await image!.readAsBytes();
      uploadTask = firebaseStorageRef.putData(
          bytes, SettableMetadata(contentType: 'image/png'));
    } else {
      uploadTask = firebaseStorageRef.putFile(File(image!.path));
    }
    TaskSnapshot taskSnapshot = await uploadTask;
    return taskSnapshot;
  }

  Future<void> _uploadToFirebase() async {
    context.loaderOverlay.show();
    bool isEdit = widget.articleModel != null;
    prefs = await SharedPreferences.getInstance();

    try {
      String uid = prefs.getString('uid')!;

      _articleModel = ArticleModel(id: '',
          authorId: uid,
          title: _titleController.text,
          imageUrl: '',
          description: _contentController.text,
          createdAt: DateTime.now());

      if (isEdit) {
        _articleModel.id = widget.articleModel!.id;
        _articleModel.imageUrl = widget.articleModel!.imageUrl;
        await ArticlesRepository().updateArticle(_articleModel);
      } else {
        DocumentReference reference = await ArticlesRepository().addArticle(_articleModel);
        _articleModel.id = reference.id;
      }

      if (_thumbnail.path != '') {
        await FirebaseStorage.instance.ref('articles/${_articleModel.id}').listAll().then((value) {
          for (Reference element in value.items) {
            FirebaseStorage.instance.ref(element.fullPath).delete();
          }
        });

        TaskSnapshot snapshot = await _uploadImage(_articleModel.id, _thumbnail);
        String url = await snapshot.ref.getDownloadURL();
        _articleModel.imageUrl = url;

        await ArticlesRepository().updateArticle(_articleModel);
      }

      Future.delayed(Duration.zero, () {
        context.loaderOverlay.hide();
        SharedCode.navigatorReplace(context, ArticleAddedPage(isEdit: isEdit));
      });
    } catch (e) {
      SharedCode.showSnackBar(context, false, e.toString());
    }
    context.loaderOverlay.hide();
  }
}
