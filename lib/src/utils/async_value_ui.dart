import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:the_helper/src/common/widget/snack_bar.dart';

final Set<String> _showingSnackbar = {};

const shiftSnackbarName = 'shift';
const myShiftSnackbarName = 'myShift';
const rateShiftSnackbarName = 'rateShift';
const roleAssignmentSnackbarName = 'roleAssignment';
const transferOwnershipSnackbarName = 'transferOwnership';
const createNewsSnackbarName = 'createNews';
const deleteNewsSnackbarName = 'deleteNews';
const createChatGroupSnackbarName = 'createChatGroup';
const chatGroupParticipantAddSnackbarName = 'chatGroupParticipantAdd';
const chatGroupParticipantRemoveSnackbarName = 'chatGroupParticipantRemove';
const chatGroupMakeOwnerSnackbarName = 'chatGroupMakeOwner';
const chatGroupUpdateSnackbarName = 'chatGroupUpdate';
const chatGroupLeaveSnackbarName = 'chatGroupLeave';
const chatGroupDeleteSnackbarName = 'chatGroupDelete';
const grantAdminSnackbarName = 'grantAdmin';
const revokeAdminSnackbarName = 'revokeAdmin';

extension AsyncValueUI on AsyncValue {
  void showSnackbarOnError(
    BuildContext context, {
    String? name,
  }) {
    if (!isLoading && !isRefreshing && asError != null) {
      if (name != null) {
        if (_showingSnackbar.contains(name)) {
          return;
        }
        _showingSnackbar.add(name);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
            errorSnackBarFromException(error!),
          )
          .closed
          .then((value) {
        _showingSnackbar.remove(name);
      });
    }
  }

  void showSnackbarOnSuccess(
    BuildContext context, {
    Widget? content,
    SnackBarBehavior? behavior,
    String? name,
  }) {
    if (!isLoading && !isRefreshing && asData != null) {
      if (name != null) {
        if (_showingSnackbar.contains(name)) {
          return;
        }
        _showingSnackbar.add(name);
      }

      ScaffoldMessenger.of(context)
          .showSnackBar(
            SnackBar(
              content: content ??
                  const Text(
                    'Success',
                  ),
              showCloseIcon: true,
              behavior: behavior,
            ),
          )
          .closed
          .then((value) => _showingSnackbar.remove(name));
    }
  }
}
