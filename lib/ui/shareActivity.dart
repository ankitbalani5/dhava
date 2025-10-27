
import 'package:coherent_endurance/resources/image/appImages.dart';
import 'package:coherent_endurance/resources/style/textStyle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'dart:io';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

void showShareActivitySheet({
  required BuildContext context,
  required ImageProvider imageProvider,
  required String distance,
  required String time,
  required String elevation,
  required String title,
  required String link,
}) {
  final ScreenshotController screenshotController = ScreenshotController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.85,
        maxChildSize: 0.95,
        minChildSize: 0.7,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: const Text(
                    "Share Activity",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                const SizedBox(height: 10),

                // Screenshot area
                Expanded(
                  child: Center(
                    child: Screenshot(
                      controller: screenshotController,
                      child: AspectRatio(
                        aspectRatio: 9 / 16,
                        child: Stack(
                          children: [
                            // Background Image
                            Container(
                              height: MediaQuery.of(context).size.height*.60,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),

                            // Gradient overlay
                            Container(
                              height: MediaQuery.of(context).size.height*.60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.black.withOpacity(0.1),
                                    Colors.black.withOpacity(0.5),
                                  ],
                                ),
                              ),
                            ),

                            // Stats text
                            Positioned(
                              bottom: 10,
                              left: 20,
                              right: 20,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                    children: [
                                      _buildStat("Distance", "$distance"),
                                      _buildStat("Time", time),
                                      _buildStat("Elev Gain", "$elevation m"),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Image.asset(AppImageOthers.dhavaLogo, width: 80,)
                                    /*Text(
                                      "COHERENT",
                                      style: TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),*/
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Share To', style: CustomTextStyles.bold(fontSize: 16),),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              const link = 'https://yourapp.com/activity/123'; // 👉 dynamic link daalna yahan
                              final text = '🏃‍♂️ My latest activity on Dhava!\n$link';
                              final whatsappUrl = Uri.parse('whatsapp://send?text=$text');

                              if (await canLaunchUrl(whatsappUrl)) {
                                await launchUrl(whatsappUrl);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('WhatsApp not installed!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImageOthers.whatsapp, height: 40,),
                                SizedBox(height: 10,),
                                Text('Whatsapp')
                              ],
                            ),
                          ),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap: () async {
                              const link = 'https://yourapp.com/activity/123';
                              final text = Uri.encodeComponent('🏃‍♂️ My latest activity on Dhava!\n$link');
                              final smsUrl = Uri.parse('sms:?body=$text');

                              if (await canLaunchUrl(smsUrl)) {
                                await launchUrl(smsUrl);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Messages app not available!'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImageOthers.message, height: 40),
                                SizedBox(height: 10,),
                                Text('Message')
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              const link = 'https://yourapp.com/activity/123'; // 👈 अपना actual link यहाँ डालो
                              final textToCopy = '🏃‍♂️ My latest activity on Dhava!\n$link';

                              await Clipboard.setData(ClipboardData(text: textToCopy));

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Link copied to clipboard!'),
                                  behavior: SnackBarBehavior.floating,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImageOthers.copyLink, height: 20,),
                                SizedBox(height: 10,),
                                Text('Copy Link')
                              ],
                            ),
                          ),
                          SizedBox(width: 20,),
                          GestureDetector(
                            onTap: () async {
                              try {
                                // Capture screenshot safely
                                final image = await screenshotController.capture();
                                if (image == null) return;

                                // Create temp file
                                final directory = await getTemporaryDirectory();
                                final filePath = '${directory.path}/shared_activity.png';
                                final file = await File(filePath).create();
                                await file.writeAsBytes(image);

                                // Use root context for Share dialog (not bottom sheet context)
                                if (context.mounted) {
                                  // Navigator.of(context).pop(); // Close the sheet before sharing (optional)
                                  await Share.shareXFiles(
                                    [XFile(file.path)],
                                    text: '🏃‍♂️ My latest activity on Dhava! \n$link',
                                  );
                                }
                              } catch (e) {
                                debugPrint("Share failed: $e");
                              }
                            },
                            child: Column(
                              children: [
                                Image.asset(AppImageOthers.share, height: 20),
                                SizedBox(height: 10,),
                                Text('Share')
                              ],
                            ),
                          ),
                        ],
                      ),
                      // ElevatedButton.icon(
                      //   onPressed: () async {
                      //     final image = await screenshotController.capture();
                      //     if (image != null) {
                      //       final directory = await getTemporaryDirectory();
                      //       final path = await File(
                      //         '${directory.path}/shared_activity.png',
                      //       ).create();
                      //       await path.writeAsBytes(image);
                      //       await Share.shareXFiles(
                      //         [XFile(path.path)],
                      //         text: '🏃‍♂️ My latest activity on Coherent!',
                      //       );
                      //     }
                      //   },
                      //   icon: const Icon(Icons.share, color: Colors.white),
                      //   label: const Text(
                      //     "Share",
                      //     style: TextStyle(color: Colors.white, fontSize: 16),
                      //   ),
                      //   style: ElevatedButton.styleFrom(
                      //     backgroundColor: Colors.orange,
                      //     shape: RoundedRectangleBorder(
                      //       borderRadius: BorderRadius.circular(30),
                      //     ),
                      //     padding:
                      //     const EdgeInsets.symmetric(horizontal: 50, vertical: 14),
                      //   ),
                      // ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

Widget _buildStat(String label, String value) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(label,
          style: const TextStyle(color: Colors.white70, fontSize: 13)),
      Text(value,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
    ],
  );
}
