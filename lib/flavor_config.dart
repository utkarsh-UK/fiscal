import 'package:flutter/material.dart';

class FlavorConfig {
  String appTitle;
  Map<String, String> apiEndpoints;
  String imageLocation;
  ThemeData? themeData;

  FlavorConfig({
    this.appTitle = 'Fiscal',
    this.imageLocation='assets/',
    this.apiEndpoints = const {},
}){
    this.themeData = ThemeData.light();
  }
}