import 'package:flutter/material.dart';

final textInputDecoration = InputDecoration(
  isDense: true,
  fillColor: Color(0xFFF1F1F1),
  filled: true,
  // hintStyle: TextStyle(color: Color(0xff8D99AE)),
  labelStyle: TextStyle(color: Colors.black),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff8D99AE), width: 2.0),
    borderRadius: BorderRadius.circular(16.0),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xff8D99AE), width: 2.0),
    borderRadius: BorderRadius.circular(16.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black, width: 2.0),
    borderRadius: BorderRadius.circular(16.0),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFD00000), width: 2.0),
    borderRadius: BorderRadius.circular(16.0),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFD00000), width: 2.0),
    borderRadius: BorderRadius.circular(16.0),
  ),
);
