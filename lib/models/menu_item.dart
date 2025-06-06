import 'package:flutter/material.dart';

class MenuItem {
  final IconData icon;
  final String title;
  final List<MenuItem>? children; 

  MenuItem({
    required this.icon,
    required this.title,
    this.children,
  });
}



