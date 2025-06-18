import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pb_lms/constants/constants.dart';
import 'package:pb_lms/models/user_model.dart';
import 'package:pb_lms/providers/navigation_provider/navigation_provider.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:pb_lms/views/user_screen/bread_crumb/bread_crumb_course.dart';
import 'package:pb_lms/views/user_screen/lessons_assignments_screen/lesson_assignment_screen.dart';
import 'package:pb_lms/widgets/notched_container.dart';
import 'package:provider/provider.dart';

class ModulesScreen extends StatefulWidget {
  final int courseId;
  const ModulesScreen({required this.courseId, super.key});

  @override
  State<ModulesScreen> createState() => _ModulesScreenState();
}

class _ModulesScreenState extends State<ModulesScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.fetchCourseModule(widget.courseId).then((_) {
        setState(() {
          filteredModules = provider.modules;
        });
      });
    });
    searchController.addListener(() {
      filterModules(searchController.text);
    });
  }

  TextEditingController searchController = TextEditingController();
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  int? editId;

  List<ModuleModel> filteredModules = [];

  void filterModules(String query) {
    final provider = Provider.of<StudentProvider>(context, listen: false);
    final allModules = provider.modules;
    setState(() {
      filteredModules = allModules.where((module) {
        final title = module.title?.toLowerCase() ?? '';
        return title.contains(query.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StudentProvider>(context);
    final navProvider = Provider.of<NavigationProvider>(context, listen: false);
    final modules = provider.modules;
    final screenWidth = MediaQuery.sizeOf(context).width;

    if (navProvider.isViewingLessons) {
      return LessonAssignmentScreen();
    }

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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              // Breadcrumb Navigation
              BreadCrumb(),
              Text(
                'Modules',
                style: GoogleFonts.poppins(
                  fontSize: TextStyles.headingLarge(context),
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                'Find your modules here.',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Modules',
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
                    prefixIcon: const Icon(CupertinoIcons.search, size: 24),
                    hintText: 'Search',
                    contentPadding: EdgeInsets.only(top: 10, bottom: 10),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Align(
                alignment: provider.isLoading
                    ? Alignment.center
                    : filteredModules.length < 4
                    ? Alignment.topLeft
                    : Alignment.topCenter,
                child: provider.isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color.fromARGB(255, 12, 201, 70),
                        ),
                      )
                    : filteredModules.isEmpty
                    ? Center(
                        child: Text(
                          'No modules available',
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
                          ...filteredModules.map((item) {
                            final title = item.title ?? 'Untitled';
                            final iconPath =
                                title.trim().toLowerCase().startsWith('ui ux')
                                ? 'assets/courses/uiux.svg'
                                : 'assets/courses/course.svg';

                            return GestureDetector(
                              onTap: () =>
                                  navProvider.navigateToLessons(item.moduleId!),
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
                                  (modules.indexOf(item) + 1).toString(),
                                ),
                                child: Stack(
                                  children: [
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
            ],
          ),
        ),
      ),
    );
  }
}
