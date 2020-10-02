import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
  fillColor: Color(0xFFF5F5F5),
  filled: true,
  contentPadding: EdgeInsets.all(12.0),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0x1F000000), width: 0.0),
    borderRadius: BorderRadius.circular(5.0),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFFFFEBEE), width: 1.5),
    borderRadius: BorderRadius.circular(5.0),
  ),
);