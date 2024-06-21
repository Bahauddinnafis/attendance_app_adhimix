import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:absensi_adhimix/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class MainFeature extends StatefulWidget {
  const MainFeature({super.key});

  @override
  _MainFeatureState createState() => _MainFeatureState();
}

class _MainFeatureState extends State<MainFeature> {
  String _currentAddress = 'Ini adalah alamat saya.';

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  DateTime? checkInTime;
  DateTime? checkOutTime;

  bool isCheckInEnabled = true;
  bool isCheckOutEnabled = false;

  // Rekam Absen
  void recordAttendance() {
    DateTime now = DateTime.now();
    if (checkInTime == null && checkOutTime == null) {
      setState(() {
        checkInTime = now;
        isCheckInEnabled = false;
        isCheckOutEnabled = true;
      });
      _saveCheckInTime(now);
    } else if (checkInTime != null && checkOutTime != null) {
      setState(() {
        checkOutTime = now;
        isCheckInEnabled = true;
        isCheckOutEnabled = false;
      });
      _saveCheckOutTime(now);
    } else if (checkInTime != null && checkOutTime == null) {
      setState(() {
        checkOutTime = now;
        isCheckInEnabled = false;
        isCheckOutEnabled = false;
      });
      _saveCheckOutTime(now);
    }
  }

  Future<void> _saveCheckInTime(DateTime checkInTime) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('attendance')
            .doc(todayDate)
            .set({
          'checkInTime': checkInTime,
          'checkOutTime': null,
        });
        print('Check-in time saved to firestore: $checkInTime');
      }
    } catch (e) {
      print('Error saving check-in time');
    }
  }

  Future<void> _saveCheckOutTime(DateTime checkOutTime) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('attendance')
            .doc(todayDate)
            .update({
          'checkOutTime': checkOutTime,
        });
        print('Check-out time saved to Firestore: $checkOutTime');
      }
    } catch (e) {
      print('Error saving check-out time: $e');
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '-';
    } else {
      return DateFormat('HH:mm:ss').format(dateTime);
    }
  }

  // Logout
  Future<void> _logout(BuildContext context) async {
    try {
      await _updateUserAttendance();
      await FirebaseAuth.instance.signOut();
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        ),
        (route) => false,
      );
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  Future<void> _updateUserAttendance() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        // Update document with user's attendance data
        await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('attendance')
            .doc(todayDate)
            .update({
          'checkInTime': checkInTime,
          'checkOutTime': checkOutTime,
        });
        print('Attendance data updated successfully.');
      }
    } catch (e) {
      print('Error updating attendance data: $e');
    }
  }

  // Geolocator
  void _getCurrentLocation() async {
    try {
      var status = await Permission.location.request();
      if (status.isGranted) {
        Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        setState(() {
          _currentAddress = "${position.latitude}, ${position.longitude}";
        });
        print('Location fetched: $_currentAddress');
      } else if (status.isDenied || status.isPermanentlyDenied) {
        setState(() {
          _currentAddress = "Location permission are denied";
        });
      } else if (status.isRestricted) {
        setState(() {
          _currentAddress = "Location permission are restricted";
        });
      }
    } catch (e) {
      print("Error getting location : $e");
      setState(() {
        _currentAddress = "Failed to get location.";
      });
    }
  }

  // Get Current Attendance
  Future<void> _getCurrentUserAttendance() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        String todayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
        DocumentSnapshot userDoc = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('attendance')
            .doc(todayDate)
            .get();
        if (userDoc.exists) {
          setState(() {
            checkInTime = userDoc['checkInTime']?.toDate();
            checkOutTime = userDoc['checkOutTime']?.toDate();
          });
          print('Attendance data fetched successfully.');
        } else {
          setState(() {
            checkInTime = null;
            checkOutTime = null;
          });
          print('No attendance data for today.');
        }
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _getCurrentUserAttendance();
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    String formattedDate = DateFormat('EEEE, d MMMM yyyy').format(today);

    return Container(
      height: 316,
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
              formattedDate,
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
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 7,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48,
                  ),
                ),
                Container(
                  height: 70,
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(50),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                      width: 7,
                    ),
                  ),
                  child: Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                    size: 48,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  'Jam Masuk',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  'Jam Pulang',
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  formatDateTime(checkInTime),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                Text(
                  formatDateTime(checkOutTime),
                  style: GoogleFonts.poppins(
                    textStyle: const TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 7,
            ),
            SizedBox(
              width: 250,
              height: 35,
              child: ElevatedButton(
                onPressed: isCheckInEnabled || isCheckOutEnabled
                    ? () {
                        recordAttendance();
                        _getCurrentLocation();
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Check In/Out',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30.0),
              child: Container(
                width: 280,
                height: 37,
                decoration: BoxDecoration(
                  color: const Color(0xFFD5D7DC),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 24,
                      color: Colors.black,
                    ),
                    Expanded(
                      child: Text(
                        _currentAddress,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: GoogleFonts.poppins(
                          textStyle: const TextStyle(
                            fontSize: 9,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              'Time Zone: Asia / Jakarta',
              style: GoogleFonts.poppins(
                textStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: 100,
                  height: 27,
                  decoration: BoxDecoration(
                    color: const Color(0xFF2196F3),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Center(
                    child: Text(
                      'REFRESH',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () => _logout(context),
                  child: Container(
                    width: 100,
                    height: 27,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2196F3),
                      borderRadius: BorderRadius.circular(50),
                    ),
                    child: Center(
                      child: Text(
                        'KELUAR',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
