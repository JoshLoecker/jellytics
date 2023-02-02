extension StringPadding on int {
  String leadingZero([int extraPadding = 2]) {
    /*
    This function will add a leading zero to any integer passed in, and return it as a string
    */
    return toString().padLeft(extraPadding, "0");
  }
}
