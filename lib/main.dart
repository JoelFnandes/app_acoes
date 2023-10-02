import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'ui/home.dart';

void main() async {
  runApp(MaterialApp(
    home: Home(),
    theme:
        ThemeData(highlightColor: Colors.purple, primaryColor: Colors.purple),
  ));
}
