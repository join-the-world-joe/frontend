class Responsive {
  static bool isLarge(double width) {
    return width >= 1100;
  }

  static bool isMedium(double width) {
    return width >= 800 && width < 1100;
  }

  static bool isSmall(double width) {
    return width < 800;
  }
}