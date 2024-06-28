import 'package:flutter/material.dart';

class ThemeSwitch extends StatelessWidget {
  final bool isDarkMode;
  final Function toggleTheme;

  ThemeSwitch({required this.isDarkMode, required this.toggleTheme});

  @override
  Widget build(BuildContext context) {
    return Switch(
      value: isDarkMode,
      onChanged: (value) {
        toggleTheme();
      },
      activeColor: Colors.white,
      activeTrackColor: const Color.fromARGB(255, 1, 119, 87),
    );
  }
}
