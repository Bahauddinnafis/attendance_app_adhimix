import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReportAbsensi extends StatelessWidget {
  const ReportAbsensi({super.key});

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
            // Optional
            // Column(
            //   children: [
            //     Center(
            //       child: Text(
            //         'BAHAUDDIN NAFIS AHMAD',
            //         style: GoogleFonts.poppins(
            //           textStyle: const TextStyle(
            //             fontSize: 16,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ),
            //     Center(
            //       child: Text(
            //         '21081010308',
            //         style: GoogleFonts.poppins(
            //           textStyle: const TextStyle(
            //             fontSize: 16,
            //             color: Colors.black,
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            Container(
              margin: const EdgeInsets.all(16.0),
              child: Table(
                border: const TableBorder(
                  horizontalInside: BorderSide(color: Colors.black, width: 1),
                  verticalInside: BorderSide(color: Colors.black, width: 1),
                ),
                columnWidths: const {
                  0: FlexColumnWidth(2),
                  1: FlexColumnWidth(3),
                  2: FlexColumnWidth(2),
                  3: FlexColumnWidth(2),
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
                          color: Colors.blueGrey,
                          child: const Center(
                            child: Text(
                              'Mata Kuliah',
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
                  for (var i = 0; i < 15; i++)
                    TableRow(
                      children: [
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Center(
                              child: Text('2023-11-${29 - i}'),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Center(
                              child: Expanded(
                                child: Text(
                                  'Pemrograman Berorientasi Objek',
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Center(
                              child: Text('07:50:35'),
                            ),
                          ),
                        ),
                        TableCell(
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: const Center(
                              child: Text('17:25:54'),
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
