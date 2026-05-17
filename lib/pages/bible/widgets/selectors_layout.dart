import 'package:flutter/material.dart';

class SelectorWithLabel extends StatelessWidget {
  final String title;
  final Widget selector;

  const SelectorWithLabel({
    super.key,
    required this.title,
    required this.selector,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 20,
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 6),
        selector,
      ],
    );
  }
}
