import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SecondaryFeature extends StatefulWidget {
  const SecondaryFeature({super.key});

  @override
  State<SecondaryFeature> createState() => _SecondaryFeatureState();
}

class _SecondaryFeatureState extends State<SecondaryFeature> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? checkInTimeYesterday;
  DateTime? checkOutTimeYesterday;

  @override
  void initState() {
    super.initState();
    _getYesterdayAttendance();
  }

  Future<void> _getYesterdayAttendance() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DateTime yesterday = DateTime.now().subtract(const Duration(days: 1));
        String yesterdayDate = DateFormat('yyyy-MM-dd').format(yesterday);
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('attendance')
            .doc(yesterdayDate)
            .get();
        if (userDoc.exists) {
          setState(() {
            checkInTimeYesterday =
                (userDoc['checkInTime'] as Timestamp?)?.toDate();
            checkOutTimeYesterday =
                (userDoc['checkOutTime'] as Timestamp?)?.toDate();
          });
          print('Yesterday\'s attendance data fetched successfully.');
        }
      } else {
        setState(() {
          checkInTimeYesterday = null;
          checkOutTimeYesterday = null;
        });
        print('No attendance data for yesterday.');
      }
    } catch (e) {
      print('Error fetching yesterday\'s data: $e');
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '-';
    } else {
      return DateFormat('HH:mm:ss').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    DateTime yesterday = today.subtract(const Duration(days: 1));

    String formattedYesterday =
        DateFormat('EEEE, d MMMM yyyy').format(yesterday);

    return Container(
      height: 79,
      width: 320,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4.0),
        child: Column(
          children: [
            Text(
              formattedYesterday,
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Container(
              height: 1,
              width: 300,
              decoration: const BoxDecoration(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text(
                      'Jam Masuk',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      formatDateTime(checkInTimeYesterday),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Jam Pulang',
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      formatDateTime(checkOutTimeYesterday),
                      style: GoogleFonts.poppins(
                        textStyle: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
