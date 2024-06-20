import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ReportAbsensi extends StatefulWidget {
  const ReportAbsensi({super.key});

  @override
  State<ReportAbsensi> createState() => _ReportAbsensiState();
}

class _ReportAbsensiState extends State<ReportAbsensi> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<Map<String, dynamic>> allAttendanceData = [];

  @override
  void initState() {
    super.initState();
    _getAllAttendanceData();
  }

  Future<void> _getAllAttendanceData() async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        QuerySnapshot attendanceSnapShot = await _firestore
            .collection('users')
            .doc(user.uid)
            .collection('attendance')
            .get();

        List<Map<String, dynamic>> attendanceData = [];
        for (var doc in attendanceSnapShot.docs) {
          var data = doc.data() as Map<String, dynamic>;
          DateTime? checkInTime = data['checkInTime']?.toDate();
          DateTime? checkOutTime = data['checkOutTime']?.toDate();
          String date = doc.id;

          attendanceData.add({
            'date': date,
            'checkInTime': checkInTime,
            'checkOutTime': checkOutTime,
          });

          setState(() {
            allAttendanceData = attendanceData;
          });
          print('All attendance data fetched successfully.');
        }
      } else {
        print('User not logged in.');
      }
    } catch (e) {
      print('Error fetching attendance data: $e');
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(
          'Report Absensi',
          style: GoogleFonts.poppins(
            textStyle: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Table(
                border: const TableBorder(
                  horizontalInside: BorderSide(color: Colors.black, width: 1),
                  verticalInside: BorderSide(color: Colors.black, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(2),
                  2: FlexColumnWidth(2),
                },
                children: [
                  TableRow(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                    ),
                    children: [
                      TableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.green,
                          child: const Center(
                            child: Text(
                              'Tanggal',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.orange,
                          child: const Center(
                            child: Text(
                              'Jam Datang',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      TableCell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          color: Colors.amber,
                          child: const Center(
                            child: Text(
                              'Jam Pulang',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  for (var attendance in allAttendanceData)
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(attendance['date']),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                  formatDateTime(attendance['checkInTime'])),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text(
                                  formatDateTime(attendance['checkOutTime'])),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
