import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/profile/data/profile_repository.dart';
import 'package:the_helper/src/features/profile/domain/get_profiles_data.dart';
import 'package:the_helper/src/features/profile/domain/profile.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer_query.dart';
import 'package:the_helper/src/utils/dio.dart';

import '../domain/shift_volunteer.dart';
import '../domain/shift_volunteer_query.dart';

part 'mod_shift_volunteer_service.g.dart';

class ModShiftVolunteerService {
  final Dio client;
  final ProfileRepository profileRepository;
  final ShiftRepository shiftRepository;
  ModShiftVolunteerService({
    required this.client,
    required this.profileRepository,
    required this.shiftRepository,
  });
  Future<List<ShiftVolunteer>> getShiftVolunteersBriefProfile({
    ShiftVolunteerQuery? query,
  }) async {
    List<ShiftVolunteer> volunteers =
        await shiftRepository.modGetShiftVolunteers(query: query);

    final List<int> listAccountId =
        volunteers.map((volunteer) => volunteer.accountId).toList();
    final List<Profile> listProfile = await profileRepository
        .getProfiles(GetProfilesData(ids: listAccountId, includes: [
      'skills',
    ]));
    volunteers = volunteers
        .map((volunteer) => volunteer.copyWith(
            profile: listProfile
                .firstWhere((profile) => profile.id == volunteer.accountId)))
        .toList();
    return volunteers;
  }

  Future<List<Shift>> getShifts({
    ShiftQuery? query,
  }) async {
    final shifts = await shiftRepository.getShifts(query: query);
    return shifts;
  }
}

@riverpod
ModShiftVolunteerService modShiftVolunteerService(
    ModShiftVolunteerServiceRef ref) {
  return ModShiftVolunteerService(
    client: ref.watch(dioProvider),
    profileRepository: ref.watch(profileRepositoryProvider),
    shiftRepository: ref.watch(shiftRepositoryProvider),
  );
}
