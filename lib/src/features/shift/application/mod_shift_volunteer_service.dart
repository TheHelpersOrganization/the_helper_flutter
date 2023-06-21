import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/activity/data/activity_repository.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/shift/data/mod_shift_repository.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/shift_volunteer.dart';

part 'mod_shift_volunteer_service.g.dart';

class ModShiftVolunteerService {
  final Dio client;
  final ProfileRepository profileRepository;
  final ModShiftRepository modShiftRepository;
  ModShiftVolunteerService({
    required this.client,
    required this.profileRepository,
    required this.modShiftRepository,
  });
  Future<List<ShiftVolunteer>> getShiftVolunteersBriefProfile({
    Map<String, dynamic>? queryParameters,
  }) async {
    List<ShiftVolunteer> volunteers = await modShiftRepository
        .getShiftVolunteerQ(queryParameters: queryParameters);
    volunteers = await Future.wait(volunteers
        .map(
          (volunteer) async => volunteer = volunteer.copyWith(
            profile: await profileRepository
                .getBriefProfile(id: volunteer.accountId, includes: [
              'skills',
              'interested-skills',
            ], select: [
              'full-name',
              'avatar',
            ]),
          ),
        )
        .toList());
    return volunteers;
  }
}

@riverpod
ModShiftVolunteerService modShiftVolunteerService(
    ModShiftVolunteerServiceRef ref) {
  return ModShiftVolunteerService(
    client: ref.watch(dioProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
    modShiftRepository: ref.watch(modShiftRepositoryProvider),
  );
}
