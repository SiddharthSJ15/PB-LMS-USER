import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/models/user_model.dart';
import 'package:pb_lms/providers/navigation_provider/navigation_provider.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:pb_lms/views/user_screen/modules_screen/modules_screen.dart';
import 'package:pb_lms/widgets/notched_container.dart';
import 'package:provider/provider.dart';

class CoursesScreen extends StatefulWidget {
  const CoursesScreen({super.key});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.getStudentCoursesProvider().then((_) {
        setState(() {
          filteredCourses = provider.courses;
        });
      });
    });
    searchController.addListener(() {
      filterCourses(searchController.text);
    });
  }

  TextEditingController searchController = TextEditingController();
  List<CourseModel> filteredCourses = [];

  void filterCourses(String query) {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final allCourses = provider.courses;
    setState(() {
      filteredCourses = allCourses.where((course) {
        final title = course.courseName?.toLowerCase() ?? '';
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
    filteredCourses.clear();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final navProvider = Provider.of<NavigationProvider>(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    if (navProvider.isViewingModules) {
      return ModulesScreen(courseId: navProvider.selectedCourseId!,);
    }

    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        padding: const EdgeInsets.only(
          left: 20,
          top: 12,
          right: 12,
          bottom: 12,
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
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 42,
                  ),
                  Text(
                    'Courses',
                    style: GoogleFonts.poppins(
                      fontSize: TextStyles.headingLarge(context),
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    ),
                  ),
                  Text(
                    'Find your courses here.',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w300,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Courses',
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
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: searchController,
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
                              prefixIcon: const Icon(
                                CupertinoIcons.search,
                                size: 24,
                              ),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(Icons.clear),
                                      onPressed: () {
                                        searchController.clear();
                                        filterCourses('');
                                      },
                                    )
                                  : null,
              
                              hintText: 'Search',
                              contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Align(
                    alignment: provider.isLoading
                        ? Alignment.center
                        : filteredCourses.length < 4
                        ? screenWidth < 893
                              ? Alignment.topCenter
                              : Alignment.topLeft
                        : Alignment.topCenter,
                    child: provider.isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: Color.fromARGB(255, 12, 201, 70),
                            ),
                          )
                        : filteredCourses.isEmpty
                        ? Center(
                            child: Text(
                              'No courses available',
                              style: GoogleFonts.poppins(
                                fontSize: TextStyles.headingSmall(context),
                              ),
                            ),
                          )
                        : Wrap(
                            spacing: 20,
                            runSpacing: 20,
                            runAlignment: WrapAlignment.spaceEvenly,
                            alignment: WrapAlignment.start,
                            crossAxisAlignment: WrapCrossAlignment.center,
                            children: [
                              ...filteredCourses.map((course) {
                                final title = course.courseName ?? 'Untitled';
                                final iconPath =
                                    title.trim().toLowerCase().startsWith('ui ux')
                                    ? 'assets/courses/uiux.svg'
                                    : 'assets/courses/course.svg';
              
                                return // Replace your NotchedContainer GestureDetector section with this:
                                GestureDetector(
                                  onTap: () {
                                    // Navigate to modules using the provider
                                    print('Navigating to modules for course: ${course.courseId}');
                                    navProvider.navigateToModules(
                                      course.courseId!,
                                    );
                                  },
                                  child: NotchedContainer(
                                    width: 254,
                                    height: 254,
                                    backgroundColor: Colors.white,
                                    iconBackgroundColor: Colors.white,
                                    padding: const EdgeInsets.fromLTRB(
                                      30,
                                      10,
                                      10,
                                      10,
                                    ),
                                    topRightIcon: Text(
                                      course.courseId?.toString() ?? '',
                                    ),
                                    child: Stack(
                                      children: [
                                        // Main content
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SvgPicture.asset(
                                              iconPath,
                                              height: 100,
                                              width: 100,
                                              placeholderBuilder: (context) =>
                                                  const CircularProgressIndicator(),
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              title,
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
