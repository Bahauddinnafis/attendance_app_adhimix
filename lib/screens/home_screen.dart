import 'package:absensi_adhimix/features/main_feature.dart';
import 'package:absensi_adhimix/features/secondary_feature.dart';
import 'package:absensi_adhimix/features/third_feature.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  String getGreetings() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Selamat Pagi';
    } else if (hour < 18) {
      return 'Selamat Siang';
    } else {
      return 'Selamat Malam';
    }
  }

  @override
  Widget build(BuildContext context) {
    String greeting = getGreetings();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(150),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          ),
          child: AppBar(
            flexibleSpace: Stack(
              children: [
                const Image(
                  image: AssetImage('assets/images/product_readymix.jpg'),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.8),
                  width: double.infinity,
                  height: double.infinity,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 60, left: 25, right: 35),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: greeting,
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: '\n$username',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            TextSpan(
                              text: '\nMata Kuliah Aplikasi Mobile',
                              style: GoogleFonts.poppins(
                                textStyle: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(
                            color: Colors.white,
                            width: 2,
                          ),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 48,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Center(
          child: Column(
            children: [
              // Container Secondary Feature
              SecondaryFeature(),
              SizedBox(
                height: 14,
              ),

              // Container Main Feature
              MainFeature(),
              SizedBox(
                height: 22,
              ),

              // Row Third Feature
              ThirdFeature()
            ],
          ),
        ),
      ),
    );
  }
}
