import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:jellytics/views/library/query.dart';
part 'libraries.freezed.dart';

/// Can't use "extends", as freezed doesn't support it
/// From: https://github.com/rrousselGit/freezed/issues/464

@freezed
class ItemDetailInfoNew with _$ItemDetailInfoNew {
  const factory ItemDetailInfoNew({
    required String name,
    required String id,
    required BaseItemKind baseItemKind,
    String? posterImagePath,
    String? backdropImagePath,
    List<dynamic>? imageInfo,
    String? overview,
    String? genre,
    String? releaseYear,
    String? tmdbID,
    String? imdbID,
  }) = _ItemDetailInfoNew;
}
