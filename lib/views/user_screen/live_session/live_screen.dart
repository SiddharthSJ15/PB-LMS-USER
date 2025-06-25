import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:provider/provider.dart';

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

            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: provider.live == null
                    ? Center(
                        child: Text(
                          'No live session available.',
                          style: GoogleFonts.poppins(
                            fontSize: TextStyles.headingSmall(context),
                          ),
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              provider.live!['message'] ?? '',
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Link: ${provider.live!['liveLink'] ?? 'N/A'}',
                              style: GoogleFonts.poppins(),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Start Time: ${provider.live!['liveStartTime'] ?? 'N/A'}',
                              style: GoogleFonts.poppins(),
                            ),
                          ],
                        ),
                      ),
              ),
            ),

            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
