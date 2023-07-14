import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/data/current_organization_repository.dart';

import '../data/mod_organization_repository.dart';

part 'mod_organization_service.g.dart';

class ModOrganizationService {
  final ModOrganizationRepository organizationRepository;
  final CurrentOrganizationRepository currentOrganizationRepository;

  const ModOrganizationService({
    required this.organizationRepository,
    required this.currentOrganizationRepository,
  });

  Future<int?> getCurrentOrganizationId() async {
    print('addd');
    final orgId =
        await currentOrganizationRepository.getCurrentOrganizationId();
    return orgId;
  }
}

@riverpod
ModOrganizationService modOrganizationService(ModOrganizationServiceRef ref) {
  return ModOrganizationService(
    organizationRepository: ref.watch(modOrganizationRepositoryProvider),
    currentOrganizationRepository:
        ref.watch(currentOrganizationRepositoryProvider),
  );
}
