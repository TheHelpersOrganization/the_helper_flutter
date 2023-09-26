import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/common/riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
// import 'package:riverpod_infinite_scroll/riverpod_infinite_scroll.dart';
import 'package:the_helper/src/features/shift/application/mod_shift_volunteer_service.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/attendance.dart';
import 'package:the_helper/src/features/shift/domain/list_attendance.dart';
import 'package:the_helper/src/features/shift/domain/many_query_response.dart';
import 'package:the_helper/src/features/shift/domain/shift.dart';
import 'package:the_helper/src/features/shift/domain/shift_query.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer_arg.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer_query.dart';

part 'shift_volunteer_controller.g.dart';

final isSearchingProvider = StateProvider.autoDispose<bool>((ref) => false);
final searchPatternProvider = StateProvider.autoDispose<String?>((ref) => null);
final selectedVolunteerProvider =
    StateProvider.autoDispose<Set<ShiftVolunteer>>((ref) => {});

final sliderValueProvider = StateProvider<double>((ref) => 0.0);
final textValueProvider = StateProvider<String>((ref) => '');

class ShiftVolunteerListPagedNotifier
    extends PagedNotifier<int, ShiftVolunteer> {
  final ModShiftVolunteerService modShiftVolunteerService;
  final int shiftId;
  final List<ShiftVolunteerStatus> status;
  final String? searchPattern;

  ShiftVolunteerListPagedNotifier({
    required this.modShiftVolunteerService,
    required this.shiftId,
    required this.status,
    this.searchPattern,
  }) : super(
          load: (page, limit) {
            return modShiftVolunteerService.getShiftVolunteersBriefProfile(
              query: ShiftVolunteerQuery(
                shiftId: shiftId,
                limit: limit,
                offset: page * limit,
                status: status,
                name: searchPattern?.trim().isNotEmpty == true
                    ? searchPattern!.trim()
                    : null,
                active: true,
                include: [
                  ShiftVolunteerQueryInclude.overlappingCheck,
                  ShiftVolunteerQueryInclude.travelingConstrainedCheck,
                ],
              ),
            );
          },
          nextPageKeyBuilder: NextPageKeyBuilderDefault.mysqlPagination,
        );
}

final shiftVolunteerListPagedNotifierProvider =
    StateNotifierProvider.autoDispose.family<ShiftVolunteerListPagedNotifier,
        PagedState<int, ShiftVolunteer>, ShiftVolunteerArg>(
  (ref, shiftVolunteerArg) => ShiftVolunteerListPagedNotifier(
    modShiftVolunteerService: ref.watch(modShiftVolunteerServiceProvider),
    shiftId: shiftVolunteerArg.shiftId,
    status: shiftVolunteerArg.status,
    searchPattern: ref.watch(searchPatternProvider),
  ),
);

@riverpod
class ChangeVolunteerStatusController
    extends _$ChangeVolunteerStatusController {
  @override
  FutureOr<ShiftVolunteer?> build() {
    return null;
  }

  Future<ShiftVolunteer?> approveVolunteer(
    ShiftVolunteer volunteer,
  ) async {
    state = const AsyncValue.loading();
    final response = await AsyncValue.guard(
        () async => await ref.watch(shiftRepositoryProvider).approveVolunteer(
              shiftId: volunteer.shiftId,
              volunteerId: volunteer.id,
            ));
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }

  Future<ShiftVolunteer?> rejectVolunteer(
    ShiftVolunteer volunteer,
  ) async {
    state = const AsyncLoading();
    final response = await AsyncValue.guard(
        () async => await ref.watch(shiftRepositoryProvider).rejectVolunteer(
              shiftId: volunteer.shiftId,
              volunteerId: volunteer.id,
            ));
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }

  Future<ShiftVolunteer?> removeVolunteer(
    ShiftVolunteer volunteer,
  ) async {
    state = const AsyncLoading();
    final response = await AsyncValue.guard(
        () async => await ref.watch(shiftRepositoryProvider).removeVolunteer(
              shiftId: volunteer.shiftId,
              volunteerId: volunteer.id,
            ));
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }

  Future<ShiftVolunteer?> reviewVolunteer(
    ShiftVolunteer volunteer, {
    required double completion,
    required String reviewNote,
  }) async {
    state = const AsyncLoading();
    final response = await AsyncValue.guard(
      () async => await ref.watch(shiftRepositoryProvider).reviewVolunteer(
            shiftId: volunteer.shiftId,
            volunteerId: volunteer.id,
            completion,
            reviewNote,
          ),
    );
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }

  Future<ShiftVolunteer?> toggleVerifyAttendance(
    ShiftVolunteer volunteer, {
    required bool checkIn,
  }) async {
    state = const AsyncLoading();
    final response = await AsyncValue.guard(() async {
      final checkedIn = volunteer.isCheckInVerified ?? false;
      final checkedOut = volunteer.isCheckOutVerified ?? false;
      return await ref.watch(shiftRepositoryProvider).verifyAttendance(
            shiftId: volunteer.shiftId,
            volunteerId: volunteer.id,
            attendance: Attendance(
              checkedIn: checkIn ? !checkedIn : checkedIn,
              checkedOut: !checkIn ? !checkedOut : checkedOut,
            ),
          );
    });
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }
}

@riverpod
class ChangeVolunteersStatusController
    extends _$ChangeVolunteersStatusController {
  @override
  FutureOr<ManyQueryResponse?> build() {
    return null;
  }

  Future<ManyQueryResponse?> approveVolunteers({
    required int shiftId,
    required List<int> volunteerIds,
  }) async {
    state = const AsyncValue.loading();
    final response = await AsyncValue.guard(() async =>
        await ref.watch(shiftRepositoryProvider).approveManyVolunteer(
              shiftId: shiftId,
              volunteerIds: volunteerIds,
            ));
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }

  Future<ManyQueryResponse?> rejectVolunteers({
    required int shiftId,
    required List<int> volunteerIds,
  }) async {
    state = const AsyncValue.loading();
    final response = await AsyncValue.guard(() async =>
        await ref.watch(shiftRepositoryProvider).rejectManyVolunteer(
              shiftId: shiftId,
              volunteerIds: volunteerIds,
            ));
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }

  Future<ManyQueryResponse?> removeVolunteers({
    required int shiftId,
    required List<int> volunteerIds,
  }) async {
    state = const AsyncValue.loading();
    final response = await AsyncValue.guard(() async =>
        await ref.watch(shiftRepositoryProvider).removeManyVolunteer(
              shiftId: shiftId,
              volunteerIds: volunteerIds,
            ));
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }

  Future<ManyQueryResponse?> toggleVerifyAttendance({
    required int shiftId,
    required List<ShiftVolunteer> volunteers,
    required bool checkIn,
  }) async {
    state = const AsyncLoading();
    final response = await AsyncValue.guard(() async {
      return await ref.watch(shiftRepositoryProvider).verifyManyAttendance(
            shiftId: shiftId,
            volunteers: ListAttendance(
                volunteers: volunteers.map((volunteer) {
              final checkedIn = volunteer.isCheckInVerified ?? false;
              final checkedOut = volunteer.isCheckOutVerified ?? false;
              return Attendance(
                id: volunteer.id,
                checkedIn: checkIn ? !checkedIn : checkedIn,
                checkedOut: !checkIn ? !checkedOut : checkedOut,
              );
            }).toList()),
          );
    });
    ref.invalidate(shiftVolunteerListPagedNotifierProvider);
    state = response;
    return null;
  }
}

@riverpod
Future<Shift> getShift(GetShiftRef ref, {required int shiftId}) =>
    ref.watch(shiftRepositoryProvider).getShiftById(
          id: shiftId,
          query: const ShiftQuery(
            include: [
              ShiftQueryInclude.shiftSkill,
            ],
          ),
        );
