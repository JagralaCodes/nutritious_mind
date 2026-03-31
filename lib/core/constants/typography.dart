import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTypography {
  AppTypography._();

  static TextStyle display = GoogleFonts.poppins(fontSize: 32, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle heading1 = GoogleFonts.poppins(fontSize: 28, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle heading2 = GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle heading3 = GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle bodyLarge = GoogleFonts.inter(fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle bodyMedium = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w400, color: Colors.white);
  static TextStyle bodySmall = GoogleFonts.inter(fontSize: 12, color: const Color(0xFFA0A0A0));
  static TextStyle labelLarge = GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white);
  static TextStyle button = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white);
  static TextStyle mono = GoogleFonts.jetBrainsMono(fontSize: 24, fontWeight: FontWeight.w700, color: Colors.white);
  static TextStyle monoLarge = GoogleFonts.jetBrainsMono(fontSize: 40, fontWeight: FontWeight.w700, color: Colors.white);
}
