import 'dart:async';

import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:the_helper/src/features/shift/data/shift_repository.dart';
import 'package:the_helper/src/features/shift/domain/shift_volunteer.dart';

import '../../application/mod_shift_volunteer_service.dart';

part 'shift_volunteer_controller.g.dart';

// @riverpod
// Future<List<ShiftVolunteer>> shiftVolunteerController(
//   ShiftVolunteerControllerRef ref, {
//   required shiftId,
//   required int page,
//   required int size,
//   required bool isPending,
// }) async {
//   final keepAliveLink = ref.keepAlive();
//   Timer(const Duration(minutes: 5), () {
//     keepAliveLink.close();
//   });
//   final ModShiftRepository shiftRepository =
//       ref.watch(modShiftRepositoryProvider);
//   final List<ShiftVolunteer> volunteers =
//       await shiftRepository.getShiftVolunteerQ(queryParameters: {
//     'shiftId': shiftId,
//     'status': isPending ? 'pending' : 'approved',
//     'limit': size,
//     'offset': page * size,
//   });
//   return volunteers;
// }
enum ApplicantStatus {
  all,
  satisfied,
  unsatisfied,
}

enum OtherStatus {
  all,
  rejected,
  cancelled,
}

@riverpod
class OtherTabFilter extends _$OtherTabFilter {
  @override
  OtherStatus build() {
    return OtherStatus.all;
  }
}

@riverpod
class ApplicantFilter extends _$ApplicantFilter {
  @override
  ApplicantStatus build() {
    return ApplicantStatus.all;
  }
}

@riverpod
class ShiftVolunteerController extends _$ShiftVolunteerController {
  @override
  FutureOr<List<ShiftVolunteer>> build({
    required int shiftId,
    required int offset,
    required int limit,
    String? status,
  }) {
    return _getShiftVolunteer();
  }

  Future<List<ShiftVolunteer>> _getShiftVolunteer() async {
    final ModShiftVolunteerService modShiftRepository =
        ref.watch(modShiftVolunteerServiceProvider);
    String? st;
    switch (status) {
      case 'Applicant':
        st = 'pending';
        break;
      case 'Participants':
        st = 'approved';
        break;
      case 'Other':
        st = 'rejected,removed,left';
        break;
      default:
        break;
    }
    final List<ShiftVolunteer> volunteers =
        await modShiftRepository.getShiftVolunteersBriefProfile(
            queryParameters: {
      'shiftId': shiftId,
      'offset': offset,
      'limit': limit,
      'status': st,
    }..removeWhere((key, value) => value == null));
    return volunteers;
  }

  Future<void> approveVolunteer(
    int accountId,
  ) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(
      () async {
        await ref.watch(shiftRepositoryProvider).approveVolunteer(
              shiftId,
              accountId,
            );
        return _getShiftVolunteer();
      },
    );
  }
}

// @riverpod
// Future<List<ShiftVolunteer>> filteredShiftOther(
//   FilteredShiftOtherRef ref, {
//   required int shiftId,
//   required int limit,
//   required int offset,
// }) {
//   final filter = ref.watch(otherTabFilterProvider);
//   final volunteers = ref.watch(shiftVolunteerControllerProvider(
//     shiftId: shiftId,
//     limit: limit,
//     offset: offset,
//   ));
//   switch (filter) {
//     case OtherStatus.all:
//       return volunteers;
//     case OtherStatus.rejected:
//       return volunteers
//           .where(
//               (volunteer) => volunteer.status == ShiftVolunteerStatus.rejected)
//           .toList();
//     case OtherStatus.cancelled:
//       return volunteers
//           .where(
//               (volunteer) => volunteer.status == ShiftVolunteerStatus.cancelled)
//           .toList();
//   }
// }

// TODO: waiting for backend satisfied query
// @riverpod
// List<ShiftVolunteer> filteredShiftApplicant(FilteredShiftApplicantRef ref) {
//   final filter = ref.watch(applicantFilterProvider);
//   final volunteers = ref.watch(shiftVolunteerControllerProvider);
//   switch (filter) {
//     case ApplicantStatus.all:
//       return volunteers;
//     case ApplicantStatus.satisfied:
//       return volunteers.where((volunteer) => volunteer.satisfied).toList();
//     case ApplicantStatus.unsatisfied:
//       return volunteers.where((volunteer) => !volunteer.satisfied).toList();
//   }
// }
