import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/animals/animals_repository.dart';
import 'package:lestari_admin/app/ui/animal_detail/animal_removed_page.dart';
import 'package:lestari_admin/app/ui/animal_form/animal_form_page.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:lestari_admin/data/models/animal_model.dart';
import 'package:lestari_admin/app/ui/animal_view/animal_view_page.dart';
import 'package:lestari_admin/widgets/custom_tag.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sizer/sizer.dart';

class AnimalDetailPage extends StatefulWidget {
  final AnimalModel animalModel;
  const AnimalDetailPage({Key? key, required this.animalModel}) : super(key: key);

  @override
  State<AnimalDetailPage> createState() => _AnimalDetailPageState();
}

class _AnimalDetailPageState extends State<AnimalDetailPage> {
  final ValueNotifier<int> _carouselIndex = ValueNotifier<int>(0);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _requestPermission();
  }

  Future<void> _requestPermission() async {
    await [Permission.camera].request();
  }

  Future<void> _showMoreMenus() async {
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100.w, 0.0, 0.0, 0.0),
      items: [
        const PopupMenuItem<String>(
          value: 'Edit',
          child: Text('Ubah Data'),
        ),
        const PopupMenuItem<String>(
          value: 'Delete',
          child: Text('Hapus Hewan'),
        ),
      ],
      elevation: 3.0,
    ).then((value) async {
      if (value == 'Edit') {
        SharedCode.navigatorPush(context, AnimalFormPage(animalModel: widget.animalModel));
      }
      if (value == 'Delete') {
        await _deleteAnimal();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: _buildAppBar(),
        body: SingleChildScrollView(
          child: Stack(children: [
            _buildCarousel(),
            Column(children: [
              SizedBox(height: 32.h),
              _buildPageIndicator(),
              _buildInfoCard(),
              _buildDetails(),
            ]),
          ]),
        ),
        bottomNavigationBar: widget.animalModel.modelUrl != '' ? _buildBottomWidget() : const SizedBox.shrink()
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 38.h,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.animalModel.imageUrls.length,
        onPageChanged: (index) {
          _carouselIndex.value = index;
        },
        itemBuilder: (_, int i) {
          return CachedNetworkImage(imageUrl: 
              widget.animalModel.imageUrls[i],
              width: 100.w,
              height: 38.h,
              fit: BoxFit.cover
          );
        },
      ),
    );
  }

  Widget _buildPageIndicator() {
    return ValueListenableBuilder(
        valueListenable: _carouselIndex,
        builder: (_, __, ___) {
          return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ...List.generate(widget.animalModel.imageUrls.length, (index) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: _buildDotIndicator(_carouselIndex.value == index),
                ))
              ]
          );
        }
    );
  }

  Widget _buildDotIndicator(bool isActive) {
    return Container(
      width: 8.0,
      height: 8.0,
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isActive ? ColorValues.accentGreen : ColorValues.lightGrey),
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
          SharedCode.navigatorPush(context, AnimalViewPage(animal: widget.animalModel,));
        },
        child: const Text('Lihat dalam 3D'),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 20.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 8.0, runSpacing: 8.0, children: [
            CustomTag(tag: widget.animalModel.classification),
            CustomTag(tag: widget.animalModel.vore),
            CustomTag(tag: widget.animalModel.conservationStatus),
          ]),
          const SizedBox(height: 8.0),
          Text(widget.animalModel.name,
              style: GoogleFonts.poppins(
                  fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 5.0),
          _buildMainInfo('Nama Ilmiah', widget.animalModel.scientificName),
          _buildMainInfo('Habitat', widget.animalModel.habitat),
          _buildMainInfo('Status Konservasi', widget.animalModel.conservationStatus),
          _buildMainInfo('Berat', widget.animalModel.weight),
          _buildMainInfo('Panjang', widget.animalModel.length),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 3,
            blurRadius: 7,
            offset: const Offset(0, 3), // changes position of shadow
          )
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailInfo('Deskripsi Singkat',
              widget.animalModel.description),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(color: Colors.grey)),
          _buildDetailInfo('Penyebab Kepunahan',
              widget.animalModel.cause.replaceAll('+', '\n')),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              child: Divider(color: Colors.grey)),
          _buildDetailInfo(
              'Upaya Pencegahan Kepunahan', widget.animalModel.prevention.replaceAll('+', '\n')),
        ],
      ),
    );
  }

  Widget _buildDetailInfo(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8.0),
        Text(description, style: GoogleFonts.poppins(fontSize: 14), textAlign: TextAlign.justify),
      ],
    );
  }

  Widget _buildMainInfo(String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Text(title,
                style: GoogleFonts.poppins(fontSize: 12, height: 1.6))),
        const SizedBox(width: 10.0),
        Expanded(
            flex: 3,
            child: Text(': $description',
                style: GoogleFonts.poppins(fontSize: 12, height: 1.6))),
      ],
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Detail Hewan', style: GoogleFonts.poppins(fontSize: 18)),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios,
            size: 20.0, color: ColorValues.grey),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: InkWell(
              onTap: _showMoreMenus,
              child: const Icon(Icons.more_vert_rounded)),
        )
      ],
    );
  }

  Future<void> _deleteAnimal() async {
    SharedCode.showAlertDialog(context, 'Hapus Hewan', 'Yakin untuk menghapus hewan ini?', 'Hapus', () async {
      context.loaderOverlay.show();

      try {
        await AnimalsRepository().deleteAnimal(widget.animalModel.id);

        Future.delayed(Duration.zero, () {
          context.loaderOverlay.hide();
          SharedCode.navigatorReplace(context, const AnimalRemovedPage());
        });
      } catch (e) {
        context.loaderOverlay.hide();
        SharedCode.navigatorReplace(context, const DashboardPage());
        SharedCode.showSnackBar(context, false, e.toString());
      }
    });
  }
}