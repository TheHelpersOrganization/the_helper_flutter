import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_setting.g.dart';

typedef ProfileSettings = Map<String, bool>;
const ProfileSettings settings = {
  'Overview': true,
  'Activity': true,
  'Organization': true,
  'Organization Role': true,
  'Detail': true,
};


@riverpod
ProfileSettings profileSettings(ProfileSettingsRef ref) {
  return settings;
}
