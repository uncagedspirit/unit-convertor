import 'package:flutter/material.dart';

import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';

class _Step {
  const _Step(this.title, this.body);
  final String title;
  final String body;
}

const _steps = [
  _Step(
    'Find a category',
    'On the Home tab, search or scroll to find what you want to convert - '
        'length, weight, temperature, and more.',
  ),
  _Step(
    'Enter a value',
    'Tap a category, then type a number using the keypad. Every other unit '
        'updates as you type.',
  ),
  _Step(
    'Switch the starting unit',
    'Tap any unit chip above the keypad, or tap a result row to swap it in '
        'as your new starting value.',
  ),
  _Step(
    'Save a conversion',
    'Tap the star next to any result to keep it in your Saved tab for '
        'quick access later.',
  ),
  _Step(
    'Customize the app',
    'Open Settings to change the accent color, switch between light and '
        'dark themes, adjust how many digits are shown, and more.',
  ),
];

class HowToUseScreen extends StatelessWidget {
  const HowToUseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    final scheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 22, 4),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      'How to use this app',
                      style: fredokaStyle(size: 20, color: neutrals.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
                itemCount: _steps.length,
                itemBuilder: (context, i) {
                  final step = _steps[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 22),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: scheme.primaryContainer,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '${i + 1}',
                            style: fredokaStyle(
                              size: 14,
                              color: scheme.onPrimaryContainer,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                step.title,
                                style: fredokaStyle(
                                  size: 16,
                                  color: neutrals.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                step.body,
                                style: jakartaStyle(
                                  size: 13.5,
                                  color: neutrals.textTertiary,
                                  height: 1.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
