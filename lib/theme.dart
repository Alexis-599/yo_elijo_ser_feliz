import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

dynamic appTheme(context) {
  return ThemeData(

    fontFamily: GoogleFonts.abel().fontFamily,

    textTheme: Theme.of(context).textTheme.apply(
      bodyColor: Colors.black,
      displayColor: Colors.black,
    ),
    dividerTheme: const DividerThemeData(
      space: 30,
      thickness: 2,
      indent: 15,
      endIndent: 15,
    ),
  );
}