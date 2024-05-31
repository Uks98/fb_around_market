import 'package:freezed_annotation/freezed_annotation.dart';

part 'categories.freezed.dart';

part 'categories.g.dart';

@freezed

sealed class Categories with _$Categories{
  factory Categories({
    String? title,
    String? docId,
  }) = _Category;

  factory Categories.fromJson(Map<String,dynamic> json) => _$CategoriesFromJson(json);
}