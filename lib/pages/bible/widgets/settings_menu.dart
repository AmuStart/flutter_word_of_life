import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  final VoidCallback onSelectBible; // 👈 ADD THIS

  const SettingsMenu({
    super.key,
    required this.onSelectBible, // 👈 ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(-40, 0), // move menu left
      icon: const Icon(
        Icons.settings,
        color: Colors.grey,
        size: 22,
      ),
      onSelected: (value) {
        if (value == 'bible') {
          onSelectBible(); // 👈 CALL IT HERE
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'theme',
          child: Text('Theme'),
        ),
        const PopupMenuItem(
          value: 'bible', // ✅ ensure lowercase
          child: Text('Bible Translation'),
        ),
        const PopupMenuItem(
          value: 'font',
          child: Text('Font Size'),
        ),
        const PopupMenuItem(
          value: 'about',
          child: Text('About'),
        ),
      ],
    );
  }
}