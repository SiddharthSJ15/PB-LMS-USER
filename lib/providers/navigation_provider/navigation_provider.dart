import 'package:flutter/material.dart';

class NavigationProvider extends ChangeNotifier {
  int _selectedIndex = 0;
  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    // This method sets the selected index for the navigation
    // and notifies listeners to update the UI.
    _selectedIndex = index;
    notifyListeners();
  }

}