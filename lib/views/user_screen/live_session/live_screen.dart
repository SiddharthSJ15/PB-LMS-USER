import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LiveScreen extends StatefulWidget {
  const LiveScreen({super.key});

  @override
  State<LiveScreen> createState() => _LiveScreenState();
}

class _LiveScreenState extends State<LiveScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.getStudentCoursesProvider();
    });
  }

  void fetchLive(int courseId, int batchId) async {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    await provider.getLiveLink(courseId, batchId);
  }

  Future<void> _launchLink(String url) async {
    try {
      final Uri uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not launch the live link'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching link: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  int? selectedCourseId;
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final live = provider.live;
    final courses = provider.courses;
    // Build DropdownMenuEntry list from courses
    final List<DropdownMenuEntry<int>> courseEntries = courses.map((course) {
      return DropdownMenuEntry<int>(
        value: course.courseId!,
        label: course.courseName!,
      );
    }).toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    bool isCompact = screenWidth < 600 || screenHeight < 600;
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 20,
          top: 12,
          right: 20,
          bottom: 12,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 235, 235, 235),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 46),

            Text(
              'Live Session Screen',
              style: GoogleFonts.poppins(
                fontSize: TextStyles.headingLarge(context),
              ),
            ),

            Text(
              'Find all your live sessions here.',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 20),

            DropdownMenu(
              dropdownMenuEntries: courseEntries,
              initialSelection: selectedCourseId,
              enableSearch: true,
              enableFilter: true,

              inputDecorationTheme: InputDecorationTheme(
                enabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide.none),
                disabledBorder: OutlineInputBorder(borderSide: BorderSide.none),
                hintStyle: TextStyle(color: Colors.black),
                fillColor: Colors.white,
                filled: true,
                floatingLabelStyle: TextStyle(color: Colors.black),
              ),
              menuStyle: MenuStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              onSelected: (value) {
                setState(() {
                  selectedCourseId = value;
                  // Find the selected course object
                  final selectedCourse = courses.firstWhere(
                    (course) => course.courseId == value,
                  );
                  final batchId = selectedCourse.batchId;
                  // Now you can use batchId as needed, for example:
                  fetchLive(selectedCourseId!, batchId!);
                });
              },
              label: const Text('Select Course'),
              width: 300,
              menuHeight: 300,
            ),

            const SizedBox(height: 20),

            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.white,
              ),
              padding: const EdgeInsets.all(16.0),
              child: provider.live == null
                  ? Center(
                      child: Text(
                        'No live session available.',
                        style: GoogleFonts.poppins(
                          fontSize: TextStyles.headingSmall(context),
                        ),
                      ),
                    )
                  : Builder(
                      builder: (context) {
                        final date = DateFormat('dd MMMM yyyy').format(
                          DateTime.parse(provider.live!['liveStartTime']),
                        );
                        final time = DateFormat('hh:mm a').format(
                          DateTime.parse(provider.live!['liveStartTime']),
                        );
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(date, style: GoogleFonts.poppins()),
                                const SizedBox(height: 8),
                                Text(time, style: GoogleFonts.poppins()),
                              ],
                            ),
                            ElevatedButton(
                              onPressed: () =>
                                  _launchLink(provider.live!['liveLink']),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(
                                  255,
                                  12,
                                  201,
                                  70,
                                ),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                              ),
                              child: const Text('Join Live'),
                            ),
                          ],
                        );
                      },
                    ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
