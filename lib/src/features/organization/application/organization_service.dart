import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class OrganizationService extends AsyncNotifier<int?> {
  @override
  FutureOr<int?> build() async {
    return null;
  }
}

final organizationServiceProvider =
    AsyncNotifierProvider<OrganizationService, int?>(
  () => OrganizationService(),
);
