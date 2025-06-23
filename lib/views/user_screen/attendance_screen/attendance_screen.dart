import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

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
    final provider = Provider.of<StudentProvider>(context);
    final attendanceCount = provider.attendanceCount;
    final screenWidth = MediaQuery.sizeOf(context).width;
    return provider.isLoading
        ? Shimmer.fromColors(
            period: const Duration(seconds: 3),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              height: 96,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          )
        : Container(
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
                      '$attendanceCount',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: TextStyles.headingSmall(context),
                        fontWeight: screenWidth <= 800
                            ? FontWeight.w600
                            : FontWeight.w400,
                        height: 1,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      'Days attended',
                      style: GoogleFonts.poppins(fontSize: 16),
                    ),
                  ],
                ),
                SvgPicture.asset('assets/calender.svg', width: 24, height: 24),
              ],
            ),
          );
  }
}

class AttendanceSelector extends StatefulWidget {
  const AttendanceSelector({super.key});

  @override
  State<AttendanceSelector> createState() => _AttendanceSelectorState();
}

class _AttendanceSelectorState extends State<AttendanceSelector> {
  void markAttendance(bool value) async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final response = await provider.submitAttendance(value);
    final date = DateFormat('yyyy-MM-dd').format(DateTime.now());
    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You have marked your attendance for: $date'),
          backgroundColor: const Color.fromRGBO(12, 201, 70, 1),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error marking your attendance'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenWidth <= 900 || screenHeight <= 600;
    final bool isMarked = provider.alreadyMarked ?? false;

    final now = DateTime.now();
    final currentMonth = DateFormat('MMMM').format(now);
    final currentDate = DateFormat('dd').format(now);

    return provider.isLoading
        ? Shimmer.fromColors(
            period: const Duration(seconds: 3),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          )
        : Container(
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
                    fontSize: screenWidth <= 800 || screenHeight <= 900
                        ? 18
                        : 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Padding(
                  padding: screenWidth > 800 || screenWidth < 1100
                      ? const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 10.0,
                        )
                      : const EdgeInsets.symmetric(
                          vertical: 20.0,
                          horizontal: 20.0,
                        ),
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
                              fontSize:
                                  screenWidth <= 800 || screenHeight <= 900
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
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (isCompact || screenHeight <= 750)
                        const SizedBox(width: 16),

                      if (isCompact || screenHeight <= 750)
                        isMarked ? _alreadyMarkedButton() : _buildButtons(),
                    ],
                  ),
                ),
                if (!isCompact && screenHeight > 750)
                  isMarked ? _alreadyMarkedButton() : _buildButtons(),
              ],
            ),
          );
  }

  Widget _alreadyMarkedButton() {
    final provider = Provider.of<StudentProvider>(context);
    if (provider.isLoading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(shape: BoxShape.circle),

              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.check, color: Colors.white, size: 40),
            ),
            const SizedBox(height: 8),
            Container(
              width: 160,
              height: 20,
              color: Colors.green, // This will shimmer
            ),
          ],
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          decoration: BoxDecoration(shape: BoxShape.circle,color: Colors.green),
          child: Icon(Icons.check_circle, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 8),
        Text(
          "Attendance already marked!",
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: Colors.green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
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
          onPressed: () {
            markAttendance(true);
          },
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
          onPressed: () {
            markAttendance(false);
          },
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
    final isLandscape = screenWidth > screenHeight;
    final provider = Provider.of<StudentProvider>(context);
    return provider.isLoading
        ? Shimmer.fromColors(
            period: const Duration(seconds: 3),
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: isCompact ? 400 : null,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          )
        : Container(
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemBuilder: (context, index) {
                    final attendance = provider.attendance[index];
                    final dateTime = DateTime.tryParse(attendance.date!)!;
                    final day = DateFormat('EEEE').format(dateTime);
                    final date = DateFormat('dd').format(dateTime);
                    final month = DateFormat('MMM').format(dateTime);
                    final year = DateFormat('yyyy').format(dateTime);
                    final isToday =
                        DateFormat('yyyy-MM-dd').format(dateTime) ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now());

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        elevation: 1,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: isToday
                              ? BorderSide(color: Colors.black, width: 2)
                              : BorderSide.none,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Date card
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: isToday
                                        ? [Colors.black, Colors.black87]
                                        : [
                                            Colors.grey.shade100,
                                            Colors.grey.shade200,
                                          ],
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      date,
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: isToday
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                    Text(
                                      month.toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        letterSpacing: 0.5,
                                        color: isToday
                                            ? Colors.white.withAlpha(230)
                                            : Colors.grey.shade600,
                                      ),
                                    ),
                                    if (screenHeight < 600 &&
                                            screenWidth < 500 ||
                                        !isLandscape)
                                      Text(
                                        year,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w900,
                                          letterSpacing: 0.5,
                                          color: isToday
                                              ? Colors.white.withAlpha(230)
                                              : Colors.grey.shade600,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                        
                              const SizedBox(width: 16),
                        
                              // Day and details
                              if (screenHeight > 600 && screenWidth > 500 ||
                                  isLandscape)
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              day,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black87,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (isToday) ...[
                                            const SizedBox(width: 4),
                                            Flexible(
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        12,
                                                      ),
                                                ),
                                                child: Text(
                                                  'Today',
                                                  style: TextStyle(
                                                    fontSize: 9,
                                                    fontWeight:
                                                        FontWeight.w600,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '$date $month $year',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey.shade600,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                ),
                        
                              // Status indicator (you can customize based on attendance status)
                              Container(
                                width: screenHeight < 600 || screenWidth < 500
                                    ? 50
                                    : 100,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  shape:
                                      screenHeight < 600 || screenWidth < 500
                                      ? BoxShape.circle
                                      : BoxShape.rectangle,
                                  borderRadius:
                                      screenHeight < 600 || screenWidth < 500
                                      ? null
                                      : BorderRadius.circular(20),
                                  color: isToday
                                      ? Colors.black
                                      : attendance.status == 'present'
                                      ? const Color.fromRGBO(
                                          12,
                                          201,
                                          70,
                                          1,
                                        ).withAlpha(179)
                                      : attendance.status == 'absent'
                                      ? Colors.red.withAlpha(179)
                                      : Colors.orange.withAlpha(179),
                                  // shape: BoxShape.circle,
                                ),
                                child: screenHeight < 600 || screenWidth < 500
                                    ? Icon(
                                        attendance.status == 'present'
                                            ? Icons.done
                                            : attendance.status == 'absent'
                                            ? Icons.close
                                            : Icons.priority_high,
                                        color: Colors.white,
                                      )
                                    : Text(
                                        attendance.status == 'present'
                                            ? 'Present'
                                            : attendance.status == 'absent'
                                            ? 'Absent'
                                            : 'N/A',
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          color:
                                              attendance.status == 'present'
                                              ? Colors.white
                                              : attendance.status == 'absent'
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                              ),
                            ],
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
