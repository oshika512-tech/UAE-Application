import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/core/theme/app.colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialMediaPage extends StatelessWidget {
  const SocialMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Social Media',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.whiteColor,
                fontSize: 20,
              ),
        ),
        backgroundColor: AppColors.primaryColor,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.whiteColor,
            size: 20,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSocialMediaCard(
                context,
                FaIcon(FontAwesomeIcons.facebookF, color: AppColors.whiteColor),
                "Follow us on Facebook",
                AppColors.facebookColor,
                () async {
                  final Uri url = Uri.parse(
                      "https://www.facebook.com/p/Ceylon-Meditation-Center-UAE-61571288357698/?");

                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              _buildSocialMediaCard(
                context,
                FaIcon(FontAwesomeIcons.whatsapp, color: AppColors.whiteColor),
                "Chat on WhatsApp",
                AppColors.whatsappColor,
                () async {
                  final number =AppData.whatsAppNumber;
                  final Uri url = Uri.parse('https://wa.me/$number');

                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              _buildSocialMediaCard(
                context,
                FaIcon(FontAwesomeIcons.instagram, color: AppColors.whiteColor),
                "Follow us on Instagram",
                AppColors.instagramColor,
                () async {
                  final Uri url = Uri.parse(
                      "https://www.instagram.com/ceylonmeditationcenteruae");

                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              _buildSocialMediaCard(
                context,
                FaIcon(FontAwesomeIcons.tiktok, color: AppColors.whiteColor),
                "Follow us on Tiktok",
                AppColors.pureBlack,
                () async {
                  final Uri url = Uri.parse(
                      "https://www.tiktok.com/@ceylon_meditation_center");

                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
              _buildSocialMediaCard(
                context,
                FaIcon(FontAwesomeIcons.youtube, color: AppColors.whiteColor),
                "Subscribe on YouTube",
                AppColors.youtubeColor,
                () {
                  // Handle Facebook tap
                },
              ),
              _buildSocialMediaCard(
                context,
                FaIcon(FontAwesomeIcons.link, color: AppColors.whiteColor),
                "Visit our website",
                AppColors.websiteColor,
                () async {
                  final Uri url =
                      Uri.parse("https://ceylonmeditationcenter.com/");

                  if (!await launchUrl(
                    url,
                    mode: LaunchMode.externalApplication,
                  )) {
                    throw Exception('Could not launch $url');
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialMediaCard(
    BuildContext context,
    FaIcon icon,
    String title,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          width: double.infinity,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: color,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              const SizedBox(width: 30),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.whiteColor,
                      fontSize: 18,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
