import 'package:flutter/material.dart';

import 'legal_document_screen.dart';

/// Contact info is intentionally a placeholder - fill in a real support
/// address before publishing.
const supportContactEmail = 'your-support-email@example.com';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const LegalDocumentScreen(
      title: 'Privacy Policy',
      lastUpdated: 'July 2026',
      sections: [
        LegalSection(
          'The short version',
          'Unit Converter & Calculator Toolkit has no account or sign-up '
              "and shows no ads. We use Firebase Analytics, a Google service, "
              'to understand - anonymously - how the app is used, so we can '
              "fix problems and improve it. That data isn't linked to your "
              'name, email, or identity. Your settings, favorites, and '
              'recently used categories are stored only on your device and '
              "are never sent anywhere, whether or not you're connected to "
              'the internet.',
        ),
        LegalSection(
          'What Firebase Analytics collects',
          'Firebase Analytics automatically collects anonymous usage '
              'information such as which screens you open, how long you use '
              'the app, your general country/language, and basic device and '
              'app info (like device model, OS version, and app version). It '
              'does not collect your name, email address, or anything you '
              'type into the converter itself.',
        ),
        LegalSection(
          'Advertising ID',
          "This app has no ads, so we've turned off collection of your "
              "device's advertising identifier entirely - Firebase Analytics "
              'never reads or uses it.',
        ),
        LegalSection(
          "What's stored on your device",
          'Separately from Firebase Analytics, the app also saves a small '
              'amount of information directly on your phone using standard '
              'Android storage, to remember your preferences (like your '
              "chosen colors and number format) and the conversions you've "
              'starred. This never leaves your device, and is deleted '
              'completely if you uninstall the app.',
        ),
        LegalSection(
          'Who processes this data',
          'Firebase Analytics is provided by Google, which acts as our '
              'data processor for this anonymous usage data. You can read '
              "Google's own privacy policy at "
              'https://policies.google.com/privacy.',
        ),
        LegalSection(
          "Children's privacy",
          "This app doesn't knowingly collect personal information from "
              'anyone, including children. If you believe a child has '
              'provided personal information through this app, contact us '
              "below and we'll address it.",
        ),
        LegalSection(
          'Changes to this policy',
          'If this policy ever changes, the update will be included in a '
              'future version of the app and posted here.',
        ),
        LegalSection(
          'Contact us',
          'Questions about this policy? Reach out at $supportContactEmail.',
        ),
      ],
    );
  }
}
