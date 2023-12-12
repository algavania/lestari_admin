import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lestari_admin/app/common/shared_code.dart';
import 'package:lestari_admin/data/models/campaign_model.dart';
import 'package:lestari_admin/app/ui/campaign_detail/campaign_detail.dart';
import 'package:lestari_admin/widgets/custom_tag.dart';
import 'package:sizer/sizer.dart';

class CustomCampaignCard extends StatelessWidget {
  final CampaignModel campaignModel;
  const CustomCampaignCard({Key? key, required this.campaignModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5)
      ),
      child: Container(
        width: 48.w,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
        child: InkWell(
          onTap: () {
            SharedCode.navigatorPush(context, CampaignDetailPage(campaignModel: campaignModel));
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(5.0),
                    child: CachedNetworkImage(imageUrl: campaignModel.imageUrls[0], fit: BoxFit.cover, width: 100.w, height: 100.h)
                ),
              ),
              const SizedBox(height: 7.0),
              Text(campaignModel.title, style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600)),
              Text(SharedCode.dateFormat.format(campaignModel.date), style: GoogleFonts.poppins(fontSize: 12)),
              const SizedBox(height: 7.0),
              Wrap(spacing: 5.0, runSpacing: 5.0, children: [
                CustomTag(tag: campaignModel.category)
              ]),
              const SizedBox(height: 3.0),
            ],
          ),
        ),
      ),
    );
  }
}