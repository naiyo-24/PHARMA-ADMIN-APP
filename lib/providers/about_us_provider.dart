import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/about_us.dart';

abstract class AboutUsRepository {
  Future<AboutUsInfo> load();
}

class InMemoryAboutUsRepository implements AboutUsRepository {
  const InMemoryAboutUsRepository();

  @override
  Future<AboutUsInfo> load() async {
    return const AboutUsInfo(
      companyName: 'Naiyo24',
      tagline: 'MR Management App',
      briefDescription:
          'Naiyo24 helps pharma teams manage MR activities, field ops, and reporting with a fast, modern admin console.',
      detailedDescription:
          'This admin app is designed for day-to-day operations — managing teams, monitoring activity, keeping records organized, and making compliance-friendly workflows easier to follow. The UI is built with a premium Material 3 design system and is optimized for clarity and speed.',
      directorName: 'Director',
      directorMessage:
          'Welcome to Naiyo24. Our goal is to simplify field operations and give your team reliable tools that stay easy to use as you scale. Thank you for trusting us with your workflow.',
      address: 'Your Office Address, City, State, Country',
      phoneNumber: '+91 90000 00000',
      email: 'support@naiyo24.com',
      website: 'https://naiyo24.com',
      logoAssetPath: 'assets/logo/naiyo24_logo.png',
      directorImageAssetPath: 'assets/images/director.jpeg',
    );
  }
}

final aboutUsRepositoryProvider = Provider<AboutUsRepository>((ref) {
  return const InMemoryAboutUsRepository();
});
