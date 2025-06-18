import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  int? _selectedCourseId;
  int? get selectedCourseId => _selectedCourseId;
  int? _selectedModuleId;
  int? get selectedModuleId => _selectedModuleId;

  bool get isViewingModules => _selectedCourseId != null;
  
  bool get isViewingLessons => _selectedModuleId != null;

  void setIndex(int index) {
    _selectedIndex = index;

    _selectedCourseId = null; 

    _selectedModuleId = null; 

    notifyListeners();
  }

  void navigateToModules(int courseId) {
    _selectedCourseId = courseId;
    notifyListeners();
  }

  void navigateBackToCourses() {
    _selectedCourseId = null;
    _selectedModuleId = null;
    notifyListeners();
  } 

  void navigateToLessons(int moduleId) {
    _selectedModuleId = moduleId;
    notifyListeners();
  }

  void navigateBackToModules() {
    _selectedModuleId = null;
    notifyListeners();
  }

}
