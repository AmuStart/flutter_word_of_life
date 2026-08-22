import 'package:flutter/material.dart';

class SettingsMenu extends StatelessWidget {
  final VoidCallback onSelectBible;
  final VoidCallback onSelectTheme;   // NEW
  final VoidCallback onSelectFontSize;

  const SettingsMenu({
    super.key,
    required this.onSelectBible,
    required this.onSelectTheme,      // NEW
    required this.onSelectFontSize,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      offset: const Offset(-40, 0),
      icon: const Icon(
        Icons.settings,
        color: Colors.grey,
        size: 22,
      ),
      onSelected: (value) {
        if (value == 'bible') {
          onSelectBible();
        } else if (value == 'theme') {
          onSelectTheme();
        } else if (value == 'font') {
          onSelectFontSize();
        }
      },
      itemBuilder: (context) => [
        const PopupMenuItem(
          value: 'theme',
          child: Text('Theme'),
        ),
        const PopupMenuItem(
          value: 'bible',
          child: Text('Bible Translation'),
        ),
        const PopupMenuItem(
          value: 'font',
          child: Row(
            children: const [
              Icon(Icons.format_size),
              SizedBox(width: 8),
              Text('Font Size')
            ],
          ),
        ),
        const PopupMenuItem(
          value: 'about',
          child: Text('About'),
        ),
      ],
    );
  }
}