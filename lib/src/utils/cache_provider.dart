import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cacheManagerProvider = Provider(
  (ref) => CacheManager(
    Config(
      'the_helper',
      stalePeriod: const Duration(days: 7),
      maxNrOfCacheObjects: 1000,
    ),
  ),
);
