class Navigation {
  final int index;
  final String image;
  final String label;
  const Navigation({
    required this.index,
    required this.image,
    required this.label,
  });
}

final List<Navigation> navigationItems = [
  Navigation(index: 0, image: 'assets/side_navigation/dashboard.svg', label: 'Dashboard'),
  Navigation(index: 1,image: 'assets/side_navigation/student_report.svg',label: 'Student Report',),
  Navigation(index: 2, image: 'assets/side_navigation/courses.svg', label: 'Courses'),
  Navigation(index: 3, image: 'assets/side_navigation/classes.svg', label: 'Classes'),
  Navigation(index: 4, image: 'assets/side_navigation/editor.svg', label: 'Editor'),
  Navigation(index: 5, image: 'assets/side_navigation/attendance.svg', label: 'Attendance'),
  Navigation(index: 6, image: 'assets/side_navigation/to_do.svg', label: 'To Do'),
  Navigation(index: 7,image: 'assets/side_navigation/live_sessions.svg',label: 'Live Session',),
  Navigation(index: 8,image: 'assets/side_navigation/live_sessions.svg',label: 'Internship',),
];
