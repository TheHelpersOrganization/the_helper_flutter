import 'dart:async';

import 'package:cross_file/cross_file.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/exception/backend_exception.dart';
import 'package:the_helper/src/features/file/data/file_repository.dart';
import 'package:the_helper/src/features/organization/data/mod_organization_repository.dart';

import '../../../contact/domain/contact.dart';
import '../../../location/domain/location.dart';
import '../../domain/organization.dart';

final currentStepProvider = StateProvider((ref) => 0);
final logoUrlProvider = StateProvider<String?>((ref) => null);
final bannerUrlProvider = StateProvider<String?>((ref) => null);

class CreateOrganizationController
    extends AutoDisposeAsyncNotifier<Organization?> {
  @override
  FutureOr<Organization?> build() {
    return null;
  }

  Future<void> createOrganization({
    required String name,
    required String email,
    required String phoneNumber,
    required String description,
    required String website,
    required XFile logo,
    XFile? banner,
    List<Location>? locations,
    List<PlatformFile>? files,
    List<Contact>? contacts,
  }) async {
    state = const AsyncLoading();
    final fileRepo = ref.read(fileRepositoryProvider);

    // Use Future so that the upload can be done in parallel
    final logoFuture = fileRepo.upload(logo);
    final bannerFuture = banner == null ? null : fileRepo.upload(banner);
    final fileFutures = files
            ?.map(
              (file) => fileRepo.uploadWithPlatformFile(
                file,
              ),
            )
            .toList() ??
        [];

    final logoModel = await logoFuture;
    final bannerModel = await bannerFuture;
    final fileModels = await Future.wait(fileFutures);

    try {
      final org = await ref.read(modOrganizationRepositoryProvider).create(
            Organization(
              name: name,
              email: email,
              phoneNumber: phoneNumber,
              description: description,
              website: website,
              logo: logoModel.id,
              banner: bannerModel?.id,
              locations: locations,
              files: fileModels.map((e) => e.id).toList(),
              contacts: contacts,
            ),
          );
      state = AsyncData(org);
    } on BackendException catch (ex) {
      state = AsyncError(ex.error.message, StackTrace.current);
      return;
    }
  }
}

final createOrganizationControllerProvider = AutoDisposeAsyncNotifierProvider<
    CreateOrganizationController, Organization?>(
  () => CreateOrganizationController(),
);
