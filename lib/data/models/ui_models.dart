import 'package:flutter/cupertino.dart';

class NavItem {
  final Widget page;
  final IconData? icon;
  final String label;
  final String? avatarUrl; // Add avatar support

  NavItem({required this.page, this.icon, required this.label, this.avatarUrl});
}
