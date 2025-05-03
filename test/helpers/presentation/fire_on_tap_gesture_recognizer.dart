import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void fireOnTapGestureRecognizer(Finder finder, String text) {
  final Element element = finder.evaluate().single;
  final RenderParagraph? paragraph = element.renderObject as RenderParagraph?;
  paragraph?.text.visitChildren((span) {
    if ((span as TextSpan).text != text) {
      return true;
    } else {
      final recognizer = span.recognizer as TapGestureRecognizer?;
      if (recognizer != null && recognizer.onTap != null) {
        recognizer.onTap!();
      }
      return false;
    }
  });
}
