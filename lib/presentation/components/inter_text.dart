import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class InterText extends StatelessWidget {
  final String text;
  int? maxLines;
  TextOverflow? overflow;
  TextAlign? textAlign;
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  bool? isUppercase;
  InterText({
    Key? key,
    this.isUppercase = false,
    required this.text,
    this.maxLines,
    this.overflow,
    this.textAlign,
    this.fontSize = 18,
    this.fontWeight,
    this.color = Colors.black,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      isUppercase == true ? text.toUpperCase() : text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: GoogleFonts.inter(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: color,
      ),
    );
  }
}
