import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenWidth <= 900 || screenHeight <= 700;

    print('$screenHeight');
    print('$screenWidth');

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
        child: isCompact
            ? _buildMobileLayout(context)
            : _buildDesktopLayout(context),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
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
          const SizedBox(height: 20),
          const AttendanceCount(),
          const SizedBox(height: 16),
          const AttendanceSelector(),
          const SizedBox(height: 20),
          Text(
            'Attendance Sheet',
            style: GoogleFonts.poppins(
              fontSize: TextStyles.regularText(context),
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 16),
          const AttendanceSheet(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
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
                  Expanded(flex: 3, child: const AttendanceSheet()),
                  const SizedBox(width: 16),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        const AttendanceCount(),
                        const SizedBox(height: 16),
                        Expanded(child: const AttendanceSelector()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        );
      },
    );
  }
}

class AttendanceCount extends StatelessWidget {
  const AttendanceCount({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Container(
      width: double.infinity,
      height: 96,
      padding: const EdgeInsets.only(left: 20, right: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '100',
                style: GoogleFonts.beVietnamPro(
                  fontSize: TextStyles.headingSmall(context),
                  fontWeight: screenWidth <= 800
                      ? FontWeight.w600
                      : FontWeight.w400,
                  height: 1,
                  color: Colors.black,
                ),
              ),
              Text('Days attended', style: GoogleFonts.poppins(fontSize: 16)),
            ],
          ),
          SvgPicture.asset('assets/calender.svg', width: 24, height: 24),
        ],
      ),
    );
  }
}

class AttendanceSelector extends StatelessWidget {
  const AttendanceSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenWidth <= 900 || screenHeight <= 600;

    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM').format(now);
    final currentDate = DateFormat('dd').format(now);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 30, 10, 30),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: isCompact || screenHeight <= 750
            ? MainAxisAlignment.spaceAround
            : MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Today's Attendance",
            style: GoogleFonts.poppins(
              fontSize: screenWidth <= 800 || screenHeight <= 900 ? 18 : 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          Padding(
            padding: screenWidth > 800 || screenWidth < 1100
                ? const EdgeInsets.symmetric(vertical: 10.0,horizontal: 10.0,)
                : const EdgeInsets.symmetric(vertical: 20.0,horizontal: 20.0,),
            child: Row(
              mainAxisAlignment: isCompact || screenHeight <= 750
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      currentDate,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth <= 800 || screenHeight <= 900
                            ? 56
                            : 68,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    Text(
                      currentMonth,
                      style: GoogleFonts.poppins(
                        fontSize: screenWidth < 800 || screenHeight < 900
                            ? 24
                            : 36,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
                if (isCompact || screenHeight <= 750) const SizedBox(width: 16),

                if (isCompact || screenHeight <= 750) _buildButtons(),
              ],
            ),
          ),
          if (!isCompact && screenHeight > 750) _buildButtons(),
        ],
      ),
    );
  }

  Widget _buildButtons() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            backgroundColor: const Color.fromRGBO(12, 201, 70, 1),
          ),
          onPressed: () {},
          child: Text(
            'Present',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: const BorderSide(color: Colors.black),
            ),
          ),
          onPressed: () {},
          child: Text(
            'Absent',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class AttendanceSheet extends StatelessWidget {
  const AttendanceSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenWidth <= 900 || screenHeight <= 700;
    return Container(
      height: isCompact ? 400 : null,
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
                color: Colors.grey.shade200,
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
    );
  }
}
