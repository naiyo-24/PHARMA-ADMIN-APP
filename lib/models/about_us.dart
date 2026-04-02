class AboutUsInfo {
  const AboutUsInfo({
    required this.companyName,
    required this.tagline,
    required this.briefDescription,
    required this.detailedDescription,
    required this.directorName,
    required this.directorMessage,
    required this.address,
    required this.phoneNumber,
    required this.email,
    required this.website,
    this.logoAssetPath,
    this.directorImageAssetPath,
  });

  final String companyName;
  final String tagline;

  final String briefDescription;
  final String detailedDescription;

  final String directorName;
  final String directorMessage;

  final String address;
  final String phoneNumber;
  final String email;
  final String website;

  final String? logoAssetPath;
  final String? directorImageAssetPath;
}
