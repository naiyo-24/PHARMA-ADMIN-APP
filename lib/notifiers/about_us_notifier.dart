import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/about_us.dart';
import '../providers/about_us_provider.dart';

class AboutUsNotifier extends AsyncNotifier<AboutUsInfo> {
  @override
  Future<AboutUsInfo> build() async {
    final repo = ref.read(aboutUsRepositoryProvider);
    return repo.load();
  }
}

final aboutUsNotifierProvider =
    AsyncNotifierProvider<AboutUsNotifier, AboutUsInfo>(AboutUsNotifier.new);
