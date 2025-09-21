import 'package:flutter/material.dart';
import 'package:meditation_center/core/constance/app.constance.dart';
import 'package:meditation_center/presentation/components/booking.card.dart';
import 'package:url_launcher/url_launcher.dart';

class ItemMenuPage extends StatelessWidget {
  const ItemMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List menuItems = [
      "මාසික සමාජිකත්වය ලබා ගැනීම සඳහා",
      "දානමය පිංකම් භාරගැනීම සඳහා",
      "⁠සම්බුද්ධ වන්දානා පිංකම භාරගැනීම සඳහා",
      "⁠ආලෝක පූජාව භාරගැනීම සඳහා",
      "⁠විශේෂ පිංකම් පිළිබඳ විස්තර සදහා",
      "⁠ඉදිරි වැඩසටහන් පෙළගැස්ම",
      "⁠whatsapp එකමුතුවට සම්බන්ධ වීම සඳහා",
      "⁠අප සන්නිවේදන ජාලය",
      "⁠අප හා සම්බන්ධ වීමට",
    ];

    Future<void> _launchUrl(
      String number,
      String text,
    ) async {
      final Uri url = Uri.parse('https://wa.me/$number/?text=තෙරුවන්සරණයි !\n$text');
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ListView.builder(
              itemCount: menuItems.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    switch (menuItems[index]) {
                      case "⁠ඉදිරි වැඩසටහන් පෙළගැස්ම":
                        // details add page
                        break;

                      case "⁠whatsapp එකමුතුවට සම්බන්ධ වීම සඳහා":
                        // whatsapp group link
                        break;

                      case "⁠අප සන්නිවේදන ජාලය":
                        // social media page
                        break;

                      case "⁠අප හා සම්බන්ධ වීමට":
                        // contact detail page
                        break;

                      default:
                        _launchUrl(
                          AppData.whatsAppNumber,
                          menuItems[index],
                        );
                    }
                  },
                  child: BookingCard(
                    text: menuItems[index],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
