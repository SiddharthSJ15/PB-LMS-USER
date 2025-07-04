import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/models/user_model.dart';
import 'package:pb_lms/providers/navigation_provider/navigation_provider.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:pb_lms/views/user_screen/bread_crumb/bread_crumb_course.dart';
import 'package:pb_lms/views/user_screen/assignment_submission/assignment_screen.dart';
import 'package:pb_lms/views/user_screen/lessons_assignments_screen/video_lesson.dart';
import 'package:pb_lms/widgets/video_player.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class LessonAssignmentScreen extends StatefulWidget {
  const LessonAssignmentScreen({super.key});

  @override
  State<LessonAssignmentScreen> createState() => _LessonAssignmentScreenState();
}

class _LessonAssignmentScreenState extends State<LessonAssignmentScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    assignmentView = false;
    lessonView = false;
    Future.microtask(() {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      final navProvider = Provider.of<NavigationProvider>(
        context,
        listen: false,
      );
      provider
          .getLessons(
            navProvider.selectedModuleId,
            navProvider.selectedCourseId,
          )
          .then((_) {
            setState(() {
              filteredLessons = provider.lessons;
            });
          });
      provider
          .getAssignments(
            navProvider.selectedModuleId,
            navProvider.selectedCourseId,
          )
          .then((_) {
            filteredAssignments = provider.assignments;
          });
      lessonSearchController.addListener(() {
        filterLessons(lessonSearchController.text);
      });
      assignmentSearchController.addListener(() {
        filterAssignments(assignmentSearchController.text);
      });
    });
  }

  void filterLessons(String query) {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final allLessons = provider.lessons;
    setState(() {
      filteredLessons = allLessons.where((lesson) {
        final title = lesson.title?.toLowerCase() ?? '';
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  void filterAssignments(String query) {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final allAssignments = provider.assignments;
    setState(() {
      filteredAssignments = allAssignments.where((assignment) {
        final title = assignment.title?.toLowerCase() ?? '';
        return title.contains(query.toLowerCase());
      }).toList();
    });
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

  List<LessonModel> filteredLessons = [];
  TextEditingController lessonSearchController = TextEditingController();

  bool assignmentView = false;
  int? selectedAssignment;
  bool lessonView = false;
  int? selectedLesson;

  int? editLessonId;
  int? editAssignmentId;
  List<AssignmentModel> filteredAssignments = [];
  TextEditingController assignmentSearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);

    if (navProvider.isViewingAssignments &&
        navProvider.selectedAssignmentId != null) {
      return AssignmentScreen(assignmentId: navProvider.selectedAssignmentId!);
    }

    if (navProvider.isViewingVideo) {
      return VideoLesson(url: navProvider.videoUrl!);
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 20,
          top: 12,
          right: 20,
          bottom: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: const Color.fromARGB(255, 235, 235, 235),
        ),
        child: ScrollbarTheme(
          data: ScrollbarThemeData(
            thumbColor: WidgetStateProperty.all(Colors.transparent),
            thumbVisibility: WidgetStateProperty.all(false),
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                BreadCrumb(),

                Text(
                  'Lessons & Assignments',
                  style: GoogleFonts.poppins(
                    fontSize: TextStyles.headingLarge(context),
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Find your lessons and assignments here',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Lessons',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),

                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextFormField(
                    controller: lessonSearchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hoverColor: Colors.white,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(CupertinoIcons.search, size: 24),
                      hintText: 'Search',
                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 12, 201, 70),
                        ),
                      )
                    : buildLessonsWidget(filteredLessons),

                const SizedBox(height: 40),
                Text(
                  'Assignments',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: TextFormField(
                    controller: assignmentSearchController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      hoverColor: Colors.white,
                      filled: true,
                      fillColor: Colors.white,
                      prefixIcon: const Icon(CupertinoIcons.search, size: 24),
                      hintText: 'Search',
                      contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 12, 201, 70),
                        ),
                      )
                    : buildAssignmentsWidget(filteredAssignments),
                SizedBox(height: 20),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLessonsWidget(List<LessonModel> lessons) {
    final navProvider = Provider.of<NavigationProvider>(context);
    if (lessons.isEmpty) {
      return Container(
        alignment: Alignment.center,
        height: 60,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Text(
          'No lessons found',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      height: lessons.length <= 5 ? null : 300,
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(Colors.black),
          radius: const Radius.circular(10),
          thickness: WidgetStateProperty.all(8),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 10, top: 10, right: 20),
          itemCount: lessons.length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            final lesson = lessons[index];
            return InkWell(
              onTap: () {
                setState(() {
                  final bool isSameLesson = selectedLesson == lesson.lessonId;
                  final bool isCurrentlyExpanded = lessonView && isSameLesson;

                  if (isCurrentlyExpanded) {
                    lessonView = false;
                    selectedLesson =
                        null; // Uncomment if you want to clear selection
                  } else {
                    selectedLesson = lesson.lessonId;
                    lessonView = true;
                  }
                });
              },
              child: Padding(
                padding: lessons.length >= 2
                    ? const EdgeInsets.fromLTRB(0, 5, 0, 5)
                    : EdgeInsets.zero,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        lesson.title ?? 'Untitled Lesson',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: [
                        // Video Link Button
                        if (lesson.videoLink != null)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = MediaQuery.of(
                                context,
                              ).size.width;
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  // onPressed: () => navProvider.navigateToVideo(
                                  //   lesson.lessonId,
                                  //   lesson.videoLink!,
                                  // ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            VideoPlayerScreen(url: lesson.videoLink!),
                                      ),
                                    );
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (screenWidth > 700) Text('Video Link'),
                                      if (screenWidth > 700) SizedBox(width: 4),
                                      Icon(Icons.play_arrow_rounded),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),

                        // PDF Link Button
                        if (lesson.pdfPath != null)
                          LayoutBuilder(
                            builder: (context, constraints) {
                              final screenWidth = MediaQuery.of(
                                context,
                              ).size.width;
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    elevation: 0,
                                    side: const BorderSide(color: Colors.black),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  onPressed: () => _launchLink(lesson.pdfPath!),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (screenWidth > 700) Text('Pdf Link'),
                                      if (screenWidth > 700) SizedBox(width: 4),
                                      Icon(Icons.picture_as_pdf_rounded),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget buildAssignmentsWidget(List<AssignmentModel> assignments) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final navProvider = Provider.of<NavigationProvider>(context);
    final provider = Provider.of<StudentProvider>(context);

    if (assignments.isEmpty) {
      return Container(
        alignment: Alignment.center,
        height: 65,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
        child: Text(
          'No assignments found',
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.grey[600],
          ),
        ),
      );
    }

    return Container(
      alignment: Alignment.center,
      height: assignments.length <= 5 ? null : 300,
      padding: const EdgeInsets.fromLTRB(20, 10, 8, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: ScrollbarTheme(
        data: ScrollbarThemeData(
          thumbColor: WidgetStateProperty.all(Colors.black),
          radius: const Radius.circular(10),
          thickness: WidgetStateProperty.all(8),
          thumbVisibility: WidgetStateProperty.all(true),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.only(bottom: 10, top: 10, right: 20),
          itemCount: assignments.length,
          shrinkWrap: true,
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
          itemBuilder: (context, index) {
            final assignment = assignments[index];
            return InkWell(
              onTap: () {
                provider.selectAssignmentById(assignment.assignmentId);
                navProvider.navigateToAssignments(assignment.assignmentId);
              },
              child: Padding(
                padding: assignments.length >= 2
                    ? const EdgeInsets.fromLTRB(0, 5, 0, 5)
                    : EdgeInsets.zero,
                child: Column(
                  children: [
                    // Main row with title and actions
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title section - takes most space but leaves room for actions
                        Expanded(
                          child: Text(
                            assignment.title!,
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 3,
                          ),
                        ),

                        SizedBox(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [Icon(Icons.arrow_forward_ios_outlined)],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
