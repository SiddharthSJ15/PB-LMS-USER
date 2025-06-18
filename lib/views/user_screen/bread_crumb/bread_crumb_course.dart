import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pb_lms/providers/navigation_provider/navigation_provider.dart';
import 'package:provider/provider.dart';

class BreadCrumb extends StatelessWidget {
  const BreadCrumb({super.key});

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if (screenWidth < 400)
        //   Row(
        //     mainAxisSize: MainAxisSize.min,
        //     children: [
        //       GestureDetector(
        //         onTap: () => navProvider.navigateBackToCourses(),
        //         child: Text(
        //           'Courses',
        //           style: GoogleFonts.poppins(
        //             fontSize: 16,
        //             fontWeight: FontWeight.w500,
        //             color: Color.fromARGB(255, 12, 201, 70),
        //           ),
        //         ),
        //       ),
        //       SizedBox(width: 8),
        //       Icon(Icons.arrow_forward_ios_rounded, size: 16),
        //     ],
        //   ),
        // if (screenWidth < 400) SizedBox(height: 10),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.start,
          runAlignment: WrapAlignment.start,
          children: [
            InkWell(
              autofocus: true,
              onTap: () => navProvider.navigateBackToCourses(),
              borderRadius: BorderRadius.circular(8),
              child: Text(
                'Courses',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Color.fromARGB(255, 12, 201, 70),
                ),
              ),
            ),

            SizedBox(width: 8),
            Icon(Icons.arrow_forward_ios_rounded, size: 16),

            SizedBox(width: 8),

            InkWell(
              onTap: navProvider.isViewingLessons
                  ? navProvider.navigateBackToModules
                  : null,
              child: Text(
                'Modules',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: navProvider.isViewingLessons
                      ? FontWeight.w500
                      : FontWeight.w600,
                  color: navProvider.isViewingLessons
                      ? Color.fromARGB(255, 12, 201, 70)
                      : Colors.black,
                ),
              ),
            ),

            if (navProvider.isViewingLessons) SizedBox(width: 8),

            if (navProvider.isViewingLessons)
              Icon(Icons.arrow_forward_ios_rounded, size: 16),

            if (navProvider.isViewingLessons) SizedBox(width: 8),

            if (navProvider.isViewingLessons)
              InkWell(
                child: Text(
                  'Lessons/Assignments',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),

            // if (navProvider.isViewingLessons)
            //   TextButton(
            //   onPressed: navProvider.isViewingAssignments
            //         ? navProvider.navigateBackToAssignments
            //         : null,
            //     child: Text(
            //       'Lessons/Assignments',
            //       style: GoogleFonts.poppins(
            //         fontWeight:
            //           navProvider.isViewingAssignments
            //               ? FontWeight.w500
            //               : FontWeight.w600,
            //       color:
            //           navProvider.isViewingAssignments
            //               ? Color.fromARGB(255, 12, 201, 70)
            //               : Colors.black,
            //       ),
            //     ),
            //   ),

            // if (navProvider.isViewingAssignments)
            //   Icon(Icons.arrow_forward_ios_rounded, size: 16),

            // if (navProvider.isViewingAssignments)
            //   Text(
            //     navProvider.selectedAssignmentName!,
            //     style: GoogleFonts.poppins(
            //       fontSize: 16,
            //       fontWeight: FontWeight.w600,
            //       color: Colors.black,
            //     ),
            //   ),
          ],
        ),
      ],
    );
  }
}
