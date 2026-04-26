import 'package:freezed_annotation/freezed_annotation.dart';

part 'promotion_model.freezed.dart';
part 'promotion_model.g.dart';

@freezed
class PromotionModel with _$PromotionModel {
  const factory PromotionModel({
    required String id,
    required String title,
    String? description,
    String? imageUrl,
    String? companyId,
    Map<String, dynamic>? company, // { id, name }
    required DateTime startsAt,
    required DateTime endsAt,
    @Default(true) bool isActive,
  }) = _PromotionModel;

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);
}
