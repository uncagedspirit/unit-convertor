import 'package:flutter/material.dart';

import '../../theme/app_neutral_colors.dart';
import '../../theme/text_styles.dart';

class LegalSection {
  const LegalSection(this.heading, this.body);
  final String heading;
  final String body;
}

/// Shared chrome for Privacy Policy / Terms of Use - a back button, title,
/// "last updated" line, and a scrollable list of heading+body sections.
class LegalDocumentScreen extends StatelessWidget {
  const LegalDocumentScreen({
    super.key,
    required this.title,
    required this.lastUpdated,
    required this.sections,
  });

  final String title;
  final String lastUpdated;
  final List<LegalSection> sections;

  @override
  Widget build(BuildContext context) {
    final neutrals = context.neutrals;
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 8, 22, 0),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  Expanded(
                    child: Text(
                      title,
                      style: fredokaStyle(size: 20, color: neutrals.textPrimary),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(22, 2, 22, 8),
              child: Text(
                'Last updated: $lastUpdated',
                style: jakartaStyle(size: 12.5, color: neutrals.textTertiary),
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(22, 8, 22, 32),
                itemCount: sections.length,
                itemBuilder: (context, i) {
                  final s = sections[i];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          s.heading,
                          style: fredokaStyle(size: 16, color: neutrals.textPrimary),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          s.body,
                          style: jakartaStyle(
                            size: 14,
                            color: neutrals.textSecondary,
                            height: 1.55,
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
