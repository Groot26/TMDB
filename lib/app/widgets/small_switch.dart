import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:flutter/material.dart';
import 'package:tmdb/utils/color_theme.dart';

Widget smallSwitch({
  bool loading = false,
  required bool current,
  required IconData firstIcon,
  required IconData secondIcon,
  required Function(bool) onChanged,
}) {
  // final theme = Theme.of(context);
  return AnimatedToggleSwitch<bool>.dual(
    current: current,
    first: false,
    second: true,
    height: 20,
    spacing: 0,
    style: ToggleStyle(
      backgroundColor: AppThemes.card,
      // borderRadius: BorderRadius.circular(30),
      // indicatorBorderRadius: BorderRadius.circular(30),
      indicatorColor: AppThemes.primary,
      borderColor: AppThemes.primary.withOpacity(0.2),
    ),
    loading: loading,
    animationDuration: const Duration(milliseconds: 500),
    borderWidth: 1,
    indicatorSize: Size(20, 20),
    loadingIconBuilder: (context, global) {
      return Padding(
        padding: const EdgeInsets.all(4),
        child: CircularProgressIndicator(color: Colors.white, strokeWidth: 1),
      );
    },
    iconBuilder: (value) {
      return Icon(
        // value ? Icons.calendar_month : Icons.today,
        value ? firstIcon : secondIcon,
        color: Colors.white,
        size: 16,
      );
    },
    onChanged: onChanged,
  );
}
