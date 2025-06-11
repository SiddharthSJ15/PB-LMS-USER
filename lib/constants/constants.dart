import 'package:flutter/material.dart';

// Material 3 Color Scheme
class AppColors {
  static const Color primary = Color(0xFF6750A4);
  static const Color onPrimary = Color(0xFFFFFFFF);
  static const Color secondary = Color(0xFF625B71);
  static const Color onSecondary = Color(0xFFFFFFFF);
  static const Color background = Color(0xFFFFFBFE);
  static const Color surface = Color(0xFFFFFBFE);
  static const Color onSurface = Color(0xFF1C1B1F);
  static const Color error = Color(0xFFB3261E);
  static const Color onError = Color(0xFFFFFFFF);
  static const Color outline = Color(0xFF79747E);
}

// Font Sizes for Different Screens
class FontSizes {
  // Mobile
  static const double mobileHeading = 24.0;
  static const double mobileSubheading = 20.0;
  static const double mobileContent = 16.0;
  static const double mobileCaption = 12.0;

  // Tablet
  static const double tabletHeading = 32.0;
  static const double tabletSubheading = 24.0;
  static const double tabletContent = 18.0;
  static const double tabletCaption = 14.0;

  // Desktop
  static const double desktopHeading = 40.0;
  static const double desktopSubheading = 28.0;
  static const double desktopContent = 20.0;
  static const double desktopCaption = 16.0;
}

// Text Styles
class AppTextStyles {
  // Heading
  static TextStyle heading(BuildContext context) {
    double fontSize = _getFontSize(context, FontSizes.mobileHeading, FontSizes.tabletHeading, FontSizes.desktopHeading);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.bold,
      color: AppColors.onSurface,
    );
  }

  // Subheading
  static TextStyle subheading(BuildContext context) {
    double fontSize = _getFontSize(context, FontSizes.mobileSubheading, FontSizes.tabletSubheading, FontSizes.desktopSubheading);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w600,
      color: AppColors.onSurface,
    );
  }

  // Content
  static TextStyle content(BuildContext context) {
    double fontSize = _getFontSize(context, FontSizes.mobileContent, FontSizes.tabletContent, FontSizes.desktopContent);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.normal,
      color: AppColors.onSurface,
    );
  }

  // Caption
  static TextStyle caption(BuildContext context) {
    double fontSize = _getFontSize(context, FontSizes.mobileCaption, FontSizes.tabletCaption, FontSizes.desktopCaption);
    return TextStyle(
      fontSize: fontSize,
      fontWeight: FontWeight.w400,
      color: AppColors.outline,
    );
  }

  // Helper to determine screen size
  static double _getFontSize(BuildContext context, double mobile, double tablet, double desktop) {
    double width = MediaQuery.of(context).size.width;
    if (width >= 1024) {
      return desktop;
    } else if (width >= 600) {
      return tablet;
    } else {
      return mobile;
    }
  }
}