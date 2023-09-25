import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: GoogleFonts.senTextTheme(),
  );
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
  );
}
