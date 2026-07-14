import 'package:flutter/material.dart';

import 'legal_document_screen.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentScreen(
      title: 'Terms of Use',
      lastUpdated: 'July 2026',
      sections: [
        LegalSection(
          'Acceptance',
          "By using Unit Converter & Calculator Toolkit, you agree to these "
              "terms. If you don't agree, please don't use the app.",
        ),
        LegalSection(
          'What this app is for',
          'Unit Converter & Calculator Toolkit helps you convert everyday '
              'measurements - length, weight, temperature, and more - for '
              'general and educational use.',
        ),
        LegalSection(
          'Accuracy disclaimer',
          "We've done our best to make every conversion accurate, but the "
              'app is provided "as is" without any warranty. Please '
              "don't rely on it as the sole source of truth for medical "
              'dosages, aviation, engineering, financial, or other '
              'decisions where a mistake could cause harm - always '
              'double-check critical calculations with a qualified '
              'professional or authoritative source.',
        ),
        LegalSection(
          'No warranty',
          'The app is provided without warranties of any kind, express or '
              'implied, including fitness for a particular purpose.',
        ),
        LegalSection(
          'Limitation of liability',
          "To the fullest extent permitted by law, we aren't liable for "
              'any damages or losses resulting from your use of this app.',
        ),
        LegalSection(
          'Changes to these terms',
          'We may update these terms from time to time. Continuing to use '
              'the app after an update means you accept the revised terms.',
        ),
      ],
    );
  }
}
