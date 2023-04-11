import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/organization/data/mod_organization_repository.dart';
import 'package:the_helper/src/features/organization/domain/organization.dart';
import 'package:the_helper/src/utils/flutter_secure_storage_provider.dart';

const String _kOrganizationId = 'organization.current_organization.id';

class CurrentOrganizationRepository {
  final FlutterSecureStorage localStorage;
  final ModOrganizationRepository modOrganizationRepository;

  CurrentOrganizationRepository({
    required this.localStorage,
    required this.modOrganizationRepository,
  });

  Future<int?> getCurrentOrganizationId() async {
    final organizationId = await localStorage.read(key: _kOrganizationId);
    if (organizationId == null) {
      return null;
    }
    return int.parse(organizationId);
  }

  Future<Organization?> setCurrentOrganization(int organizationId) async {
    final res =
        modOrganizationRepository.getOwnedOrganizationById(organizationId);
    await localStorage.write(
      key: _kOrganizationId,
      value: organizationId.toString(),
    );
    return res;
  }

  Future<Organization?> getCurrentOrganization() async {
    final id = await getCurrentOrganizationId();
    if (id == null) {
      return null;
    }
    return modOrganizationRepository.getOwnedOrganizationById(id);
  }
}

final currentOrganizationRepositoryProvider = Provider.autoDispose(
  (ref) => CurrentOrganizationRepository(
    localStorage: ref.watch(secureStorageProvider),
    modOrganizationRepository: ref.watch(modOrganizationRepositoryProvider),
  ),
);
