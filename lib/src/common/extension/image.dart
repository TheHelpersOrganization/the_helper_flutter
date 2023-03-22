import 'package:flutter/widgets.dart';
import 'package:simple_auth_flutter_riverpod/src/utils/domain_provider.dart';

extension ImageX on Image {
  static Image backend(
    int id, {
    Key? key,
    double scale = 1.0,
    ImageFrameBuilder? frameBuilder,
    ImageLoadingBuilder? loadingBuilder,
    errorBuilder,
    semanticLabel,
    excludeFromSemantics = false,
    width,
    height,
    color,
    opacity,
    colorBlendMode,
    fit,
    alignment = Alignment.center,
    repeat = ImageRepeat.noRepeat,
    centerSlice,
    matchTextDirection = false,
    gaplessPlayback = false,
    filterQuality = FilterQuality.low,
    isAntiAlias = false,
    Map<String, String>? headers,
    int? cacheWidth,
    int? cacheHeight,
  }) {
    return Image.network(
      '$domain/files/public/image/i/$id',
      key: key,
      scale: scale,
      frameBuilder: frameBuilder,
      loadingBuilder: loadingBuilder,
      errorBuilder: errorBuilder,
      semanticLabel: semanticLabel,
      excludeFromSemantics: excludeFromSemantics,
      width: width,
      height: height,
      color: color,
      opacity: opacity,
      colorBlendMode: colorBlendMode,
      fit: fit,
      alignment: alignment,
      repeat: repeat,
      centerSlice: centerSlice,
      matchTextDirection: matchTextDirection,
      gaplessPlayback: gaplessPlayback,
      filterQuality: filterQuality,
      isAntiAlias: isAntiAlias,
      headers: headers,
      cacheWidth: cacheWidth,
      cacheHeight: cacheHeight,
    );
  }
}
