import 'package:flutter/material.dart';
import 'package:namazvakti/utils/utils.dart';

class DisplayText extends StatelessWidget {
  const DisplayText(
      {super.key, this.text, this.textColor, this.fontSize, this.fontWeight});

  final String? text;
  final Color? textColor;
  final double? fontSize;
  final FontWeight? fontWeight;

  @override
  Widget build(BuildContext context) {
    return Text(text ?? "-_-",
        style: context.textTheme.headlineSmall?.copyWith(
            color: textColor ?? context.colorScheme.surface,
            fontWeight: fontWeight ?? FontWeight.bold,
            fontSize: fontSize));
  }
}
