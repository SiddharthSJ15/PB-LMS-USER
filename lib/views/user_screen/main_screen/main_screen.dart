import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pb_lms/providers/navigation_provider/navigation_provider.dart';
import 'package:pb_lms/providers/student_provider/student_provider.dart';
import 'package:pb_lms/utilities/navigation.dart';
import 'package:pb_lms/views/login_screen.dart';
import 'package:pb_lms/views/user_screen/attendance_screen/attendance_screen.dart';
import 'package:pb_lms/views/user_screen/classes_screen/classes_screen.dart';
import 'package:pb_lms/views/user_screen/courses_screen/courses_screen.dart';
import 'package:pb_lms/views/user_screen/dashboard/dashboard_screen.dart';
import 'package:pb_lms/views/user_screen/editor_screen/editor_screen.dart';
import 'package:pb_lms/views/user_screen/internship_screen/internship_screen.dart';
import 'package:pb_lms/views/user_screen/live_session/live_screen.dart';
import 'package:pb_lms/views/user_screen/student_report/student_report_screen.dart';
import 'package:pb_lms/views/user_screen/to_do/to_do_screen.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.microtask(() {
      final provider = Provider.of<StudentProvider>(context, listen: false);
      provider.getStudentProfileProvider();
    });
  }

  void _handleLogout(BuildContext context) {
    Provider.of<StudentProvider>(
      context,
      listen: false,
    ).logoutStudentProvider();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    double screenWidth = MediaQuery.sizeOf(context).width;
    double screenHeight = MediaQuery.sizeOf(context).height;
    bool isLargeScreen = screenWidth > 600 && screenHeight > 600;
    return Scaffold(
      appBar: screenWidth <= 600 || screenHeight <= 600
          ? AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10),
                  child: Image.asset(
                    'assets/logo/portfolixlms.png',
                    width: 127,
                    height: 56,
                  ),
                ),
              ],
            )
          : null,
      drawer: screenWidth <= 600 || screenHeight <= 600
          ? Drawer(
              width: 285,
              child: SideNav(
                selectedIndex: navProvider.selectedIndex,
                onItemTap: navProvider.setIndex,
                onLogout: () => _handleLogout(context),
              ),
            )
          : null,
      body: Row(
        children: [
          if (isLargeScreen)
            SideNav(
              selectedIndex: navProvider.selectedIndex,
              onItemTap: navProvider.setIndex,
              onLogout: () => _handleLogout(context),
            ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child:
                  // Use IndexedStack to switch between screens based on selected index
                  IndexedStack(
                    index: navProvider.selectedIndex,
                    children: [
                      const DashboardScreen(),
                      const StudentReportScreen(),
                      const CoursesScreen(),
                      const ClassesScreen(),
                      const EditorScreen(),
                      const AttendanceScreen(),
                      const ToDoScreen(),
                      const LiveScreen(),
                      const InternshipScreen(),
                      // Add more screens as needed
                    ],
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class SideNav extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onItemTap;
  final VoidCallback onLogout;
  const SideNav({
    super.key,
    this.selectedIndex,
    required this.onItemTap,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isLargeScreen = screenWidth > 600 && screenHeight > 600;
    final provider = Provider.of<StudentProvider>(context);
    final userDetails = provider.student;

    return SingleChildScrollView(
      child: ConstrainedBox(
        // Force the Column to be at least screen-height tall
        constraints: BoxConstraints(minHeight: screenHeight),
        child: SizedBox(
          width: 285,
          child: Column(
            // Fill parent height so spaceBetween works
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1) Top logo
              Padding(
                padding: const EdgeInsets.only(left: 7, top: 20),
                child: Image.asset(
                  'assets/logo/portfolixlms.png',
                  width: 127,
                  height: 56,
                ),
              ),

              if (!isLargeScreen) SizedBox(height: 20),

              // Center nav items (not individually scrollable;
              // the entire view scrolls as needed)
              Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: navigationItems.map((nav) {
                  return InkWell(
                    onTap: () {
                      onItemTap(nav.index);
                      if (!isLargeScreen) {
                        Navigator.pop(context);
                      }
                    },
                    child: _NavItem(
                      icon: nav.image,
                      label: nav.label,
                      isSelected: selectedIndex == nav.index,
                    ),
                  );
                }).toList(),
              ),

              // Bottom super‑admin & logout
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isLargeScreen)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 10, 10),
                      child: provider.profileLoading
                          ? Shimmer.fromColors(
                              period: const Duration(seconds: 3),
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                width: double.infinity,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8),
                                      child: Container(
                                        width: 49,
                                        height: 49,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 120,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Container(
                                          width: 187,
                                          height: 16,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              4,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container(
                              width: double.infinity,
                              height: 70,
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 224, 224, 224),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Color.fromARGB(
                                          255,
                                          255,
                                          199,
                                          214,
                                        ),
                                      ),
                                      child: Image.asset(
                                        'assets/peoples/person_7.png',
                                        width: 49,
                                        height: 49,
                                      ),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        userDetails.name ?? 'No Name',
                                        maxLines: 1,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 187,
                                        child: Text(
                                          userDetails.email ?? 'No Email',
                                          maxLines: 1,
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                    ),
                  if (!isLargeScreen) SizedBox(height: 20),
                  // Updated logout button with InkWell
                  InkWell(
                    onTap: onLogout,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/side_navigation/logout.svg',
                            height: 18,
                            width: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Logout',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: (){},
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'assets/side_navigation/help_support.svg',
                            height: 18,
                            width: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'Help & Support',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String icon;
  final String label;
  final bool isSelected;
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 10, 10, 10),
      width: 304,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Opacity(
            opacity: isSelected ? 1 : 0,
            child: Container(
              width: 9,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(15),
                  bottomRight: Radius.circular(15),
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          SvgPicture.asset(
            icon,
            height: 18,
            alignment: Alignment.centerLeft,
            width: 24,
            colorFilter: isSelected
                ? const ColorFilter.mode(Colors.black, BlendMode.srcIn)
                : const ColorFilter.mode(Colors.grey, BlendMode.srcIn),
          ),
          SizedBox(width: 12),
          Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: isSelected ? Colors.black : Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }
}
