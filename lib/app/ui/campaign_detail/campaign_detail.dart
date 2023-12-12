import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/blocs/user/user_bloc.dart';
import 'package:lestari_admin/app/common/color_values.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/app/repositories/campaigns/campaigns_repository.dart';
import 'package:lestari_admin/app/repositories/notifications/notifications_repository.dart';
import 'package:lestari_admin/app/repositories/user/user_repository.dart';
import 'package:lestari_admin/app/ui/campaign_detail/campaign_removed_page.dart';
import 'package:lestari_admin/app/ui/dashboard/dashboard_page.dart';
import 'package:lestari_admin/data/models/campaign_model.dart';
import 'package:lestari_admin/data/models/notification_model.dart';
import 'package:lestari_admin/data/models/user_model.dart';
import 'package:lestari_admin/widgets/custom_loading.dart';
import 'package:lestari_admin/widgets/custom_tag.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CampaignDetailPage extends StatefulWidget {
  final CampaignModel campaignModel;
  const CampaignDetailPage({Key? key, required this.campaignModel}) : super(key: key);

  @override
  State<CampaignDetailPage> createState() => _CampaignDetailPageState();
}

class _CampaignDetailPageState extends State<CampaignDetailPage> {
  final List<String> _reasonOptions = [
    'Pilih alasan',
    'Tidak sesuai dengan tema',
    'Konten menyinggung SARA',
    'Konten fiktif'
  ];
  final ValueNotifier<int> _carouselIndex = ValueNotifier<int>(0);
  final ValueNotifier<bool> _showValidationError = ValueNotifier<bool>(false);
  String _selectedReason = 'Pilih alasan';
  late UserModel _organizerModel;

  void _showMoreMenus(){
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(100.w, 0.0, 0.0, 0.0),
      items: [
        const PopupMenuItem<String>(
          value: 'Delete',
          child: Text('Hapus Kampanye'),
        ),
      ],
      elevation: 3.0,
    ).then((value) async {
      if (value == 'Delete') {
        await _archiveCampaign(false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: BlocProvider(
        create: (context) =>
        UserBloc(RepositoryProvider.of<UserRepository>(context))
          ..add(GetUserByIdEvent(widget.campaignModel.organizerId)),
        child: BlocBuilder<UserBloc, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return const CustomLoading();
              }
              if (state is UserInitial) {
                return Container();
              }
              if (state is UserError) {
                return Center(child: Text(state.message));
              }
              if (state is UserLoaded) {
                _organizerModel = state.userModel;
                return _buildCampaignDetail();
              }
              return Container();
            }
        ),
      ),
      bottomNavigationBar: _buildBottomWidget(),
    );
  }

  Widget _buildCampaignDetail() {
    return SingleChildScrollView(
      child: Stack(children: [
        _buildCarousel(),
        Column(children: [
          SizedBox(height: 32.h),
          _buildPageIndicator(),
          _buildInfoCard(),
          _buildDetails(),
        ]),
      ]),
    );
  }

  Widget _buildBottomWidget() {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.all(15.0),
      decoration: BoxDecoration(color:Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          spreadRadius: 5,
          blurRadius: 7,
          offset: const Offset(0, -3), // changes position of shadow
        ),
      ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (widget.campaignModel.status == 'waiting') Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _archiveCampaign(true);
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: ColorValues.pastelRed, foregroundColor: ColorValues.white),
                    child: const Text('Tolak'),
                  ),
                ),
                const SizedBox(width: 15.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _approveCampaign();
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: ColorValues.juneBud, foregroundColor: ColorValues.white),
                    child: const Text('Setujui'),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              await _launchUrl();
            },
            child: const Text('Kunjungi Situs Kampanye'),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(Uri.parse(widget.campaignModel.websiteUrl), mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch ${widget.campaignModel.websiteUrl}');
    }
  }

  Widget _buildInfoCard() {
    String status = '';
    switch (widget.campaignModel.status) {
      case 'online':
        status = 'Tampil secara publik';
        break;
      case 'waiting':
        status = 'Menunggu approval admin';
        break;
      case 'archived':
        status = 'Diarsipkan';
        break;
    }
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
          ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(spacing: 8.0, runSpacing: 8.0, children: [CustomTag(tag: widget.campaignModel.category)]),
          const SizedBox(height: 8.0),
          Text(widget.campaignModel.title, style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12.0),
          Row(children: [
            Expanded(child: _buildMainInfo(Icons.calendar_today_rounded, SharedCode.dateFormat.format(widget.campaignModel.date))),
            const SizedBox(height: 5.0),
            Expanded(child: _buildMainInfo(Icons.location_pin, widget.campaignModel.city)),
          ]),
          const SizedBox(height: 15.0),
          Text('Status: $status'),
          const SizedBox(height: 15.0),
          Row(children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(30.0),
              child: CachedNetworkImage(imageUrl: _organizerModel.imageUrl, width: 30.0, height: 30.0, fit: BoxFit.cover)
            ),
            const SizedBox(width: 10.0),
            Expanded(child: Text(_organizerModel.name, style: GoogleFonts.poppins(fontSize: 14))),
          ])
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return SizedBox(
      height: 38.h,
      child: PageView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.campaignModel.imageUrls.length,
        onPageChanged: (index) {
          _carouselIndex.value = index;
        },
        itemBuilder: (_, int i) {
          return CachedNetworkImage(imageUrl: 
              widget.campaignModel.imageUrls[i],
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
                ...List.generate(widget.campaignModel.imageUrls.length, (index) => Padding(
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

  Widget _buildDetails() {
    return Container(
      width: 100.w,
      padding: const EdgeInsets.symmetric(vertical: 25.0, horizontal: 20.0),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          spreadRadius: 3,
          blurRadius: 7,
          offset: const Offset(0, 3), // changes position of shadow
        )],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(15.0)),
      ),
      child: _buildDetailInfo('Deskripsi', widget.campaignModel.description.replaceAll('+', '\n')),
    );
  }

  Widget _buildDetailInfo(String title, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
        const SizedBox(height: 8.0),
        Text(description, style: GoogleFonts.poppins(fontSize: 14), textAlign: TextAlign.justify),
      ],
    );
  }

  Widget _buildMainInfo(IconData icon, String text) {
    return Row(children: [
      Icon(icon, color: ColorValues.grey, size: 16.0),
      const SizedBox(width: 8.0),
      Expanded(child: Text(text, style: GoogleFonts.poppins(fontSize: 14, color: ColorValues.grey)))
    ]);
  }

  AppBar _buildAppBar() {
    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      title: Text('Detail Kampanye', style: GoogleFonts.poppins(fontSize: 18)),
      leading: GestureDetector(
        onTap: () => Navigator.of(context).pop(),
        child: const Icon(Icons.arrow_back_ios, size: 20.0, color: ColorValues.grey),
      ),
      actions: [
        // InkWell(
        //     onTap: () {},
        //     child: const Icon(Icons.favorite_border_outlined)
        // ),
        if (widget.campaignModel.status == 'online')
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: InkWell(
                onTap: _showMoreMenus,
                child: const Icon(Icons.more_vert_rounded)
            ),
          ),
      ],
    );
  }

  Future<void> _approveCampaign() async {
    SharedCode.showAlertDialog(context, 'Setujui Publikasi Kampanye', 'Yakin untuk menyetujui publikasi kampanye ini?', 'Ya', () async {
      context.loaderOverlay.show();
      try {
        widget.campaignModel.status = 'online';
        await CampaignsRepository().updateCampaign(widget.campaignModel);

        Future.delayed(Duration.zero, () {
          context.loaderOverlay.hide();
          SharedCode.showSnackBar(context, true, 'Kampanye disetujui.');
          SharedCode.navigatorReplace(context, const DashboardPage(initialIndex: 1));
        });
      } catch (e) {
        context.loaderOverlay.hide();
        SharedCode.navigatorReplace(context, const DashboardPage());
        SharedCode.showSnackBar(context, false, e.toString());
      }
    });
  }

  Future<void> _archiveCampaign(bool isRejection) async {
    Widget cancelButton = TextButton(
      child: Text('Batal', style: GoogleFonts.poppins(color: ColorValues.accentGreen)),
      onPressed:  () => Navigator.of(context).pop(),
    );

    Widget continueButton = TextButton(
      onPressed: () async {
        if (_selectedReason != _reasonOptions[0]) {
          _showValidationError.value = false;
          context.loaderOverlay.show();

          try {
            // await CampaignsRepository().deleteCampaign(widget.campaignModel.id);

            widget.campaignModel.status = 'archived';
            await CampaignsRepository().updateCampaign(widget.campaignModel);

            NotificationModel notificationModel = NotificationModel(id: '', campaignTitle: widget.campaignModel.title, action: isRejection ? 'rejected' : 'removed', reason: _selectedReason, isRead: false, createdAt: DateTime.now());
            await NotificationsRepository().addNotification(notificationModel, widget.campaignModel.organizerId);

            _organizerModel.notifications = _organizerModel.notifications + 1;
            await UserRepository().updateUser(_organizerModel);

            Future.delayed(Duration.zero, () {
              context.loaderOverlay.hide();
              if (isRejection) {
                SharedCode.showSnackBar(context, true, 'Kampanye ditolak.');
                SharedCode.navigatorReplace(context, const DashboardPage(initialIndex: 1));
              } else {
                SharedCode.navigatorReplace(context, const CampaignRemovedPage());
              }
            });
          } catch (e) {
            context.loaderOverlay.hide();
            SharedCode.navigatorReplace(context, const DashboardPage());
            SharedCode.showSnackBar(context, false, e.toString());
          }
        } else {
          _showValidationError.value = true;
        }
      },
      child: Text(isRejection ? 'Lanjut' : 'Hapus', style: GoogleFonts.poppins(color: ColorValues.accentGreen)),
    );

    AlertDialog alert = AlertDialog(
      title: Text(isRejection ? 'Tolak Publikasi Kampanye' : 'Hapus Kampanye', style: GoogleFonts.poppins(fontWeight: FontWeight.w500)),
      content: StatefulBuilder(
        builder: (context, innerSetState) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(isRejection ? 'Pilih alasan penolakan publikasi kampanye' : 'Pilih alasan penghapusan kampanye'),
              const SizedBox(height: 10.0),
              _buildReasonDropdown(innerSetState),
              ValueListenableBuilder(valueListenable: _showValidationError, builder: (_, __, ___,) {
                return _showValidationError.value
                    ? Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Text('Anda belum memilih alasan', style: GoogleFonts.poppins(fontSize: 14, color: ColorValues.universityRed)),
                    )
                    : const SizedBox.shrink();
              })
            ],
          );
        }
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _buildReasonDropdown(innerSetState) {
    return InputDecorator(
      decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
              vertical: 10.0, horizontal: 5.0),
          enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: ColorValues.lightGrey),
              borderRadius: BorderRadius.circular(7.0))
      ),
      child: DropdownButtonHideUnderline(
        child: ButtonTheme(
          alignedDropdown: true,
          child: DropdownButton<String>(
            style: GoogleFonts.poppins(fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ColorValues.onyx),
            value: _selectedReason,
            isDense: true,
            isExpanded: true,
            icon: const Icon(Icons.arrow_drop_down_rounded, size: 20.0),
            onChanged: (String? value) {
              innerSetState(() {
                _selectedReason = value!;
              });
            },
            items: _reasonOptions.map<DropdownMenuItem<String>>((
                String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
