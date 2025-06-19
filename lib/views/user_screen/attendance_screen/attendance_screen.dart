import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:provider/provider.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.getAttendance();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 235, 235, 235),
        ),
        padding: const EdgeInsets.only(
          left: 20,
          top: 12,
          right: 12,
          bottom: 12,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 44),
            Text(
              'Attendance',
              style: GoogleFonts.poppins(
                fontSize: TextStyles.headingLarge(context),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            Text(
              'Find your attendance here.',
              style: GoogleFonts.poppins(
                fontSize: TextStyles.regularText(context),
                fontWeight: FontWeight.w400,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Attendance Sheet',
              style: GoogleFonts.poppins(
                fontSize: TextStyles.regularText(context),
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(8),
                      child: Consumer<StudentProvider>(
                        builder: (context, provider, child) {
                          if (provider.attendance.isEmpty) {
                            return Center(
                              child: Text(
                                'No attendance data available',
                                style: GoogleFonts.poppins(
                                  fontSize: TextStyles.regularText(context),
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54,
                                ),
                              ),
                            );
                          }
                          return ListView.builder(
                            itemCount: provider.attendance.length,
                            itemBuilder: (context, index) {
                              final attendance = provider.attendance[index];
                              return Card(
                                elevation: 0,
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    '${attendance.date} - ${attendance.status}',
                                    style: GoogleFonts.poppins(
                                      fontSize: TextStyles.regularText(context),
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        Container(
                          height: 96,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 16),
                        ),
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),
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
