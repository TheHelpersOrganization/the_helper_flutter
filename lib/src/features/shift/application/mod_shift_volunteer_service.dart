import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/shift.dart';
import '../domain/shift_query.dart';
import '../domain/shift_volunteer.dart';
import '../domain/shift_volunteer_query.dart';

part 'mod_shift_volunteer_service.g.dart';

class ModShiftVolunteerService {
  final Dio client;
  final ProfileRepository profileRepository;
  final ShiftRepository modShiftRepository;
  ModShiftVolunteerService({
    required this.client,
    required this.profileRepository,
    required this.modShiftRepository,
  });
  Future<List<ShiftVolunteer>> getShiftVolunteersBriefProfile({
    ShiftVolunteerQuery? queryParameters,
  }) async {
    List<ShiftVolunteer> volunteers = await modShiftRepository
        .getShiftVolunteersMod(query: queryParameters);
    // volunteers = await Future.wait(volunteers
    //     .map(
    //       (volunteer) async => volunteer = volunteer.copyWith(
    //         profile: await profileRepository
    //             .getBriefProfile(id: volunteer.accountId, includes: [
    //           'skills',
    //           'interested-skills',
    //         ], select: [
    //           'full-name',
    //           'avatar',
    //         ]),
    //       ),
    //     )
    //     .toList());
    return volunteers;
  }

  Future<List<Shift>> getShifts({
    ShiftQuery? query,
  }) async {
    final shifts = await modShiftRepository.getShifts(query: query);
    return shifts;
  }
}

@riverpod
ModShiftVolunteerService modShiftVolunteerService(
    ModShiftVolunteerServiceRef ref) {
  return ModShiftVolunteerService(
    client: ref.watch(dioProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
    modShiftRepository: ref.watch(shiftRepositoryProvider),
  );
}
