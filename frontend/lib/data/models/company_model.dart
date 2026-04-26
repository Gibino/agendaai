import 'package:freezed_annotation/freezed_annotation.dart';
import 'category_model.dart';

part 'company_model.freezed.dart';
part 'company_model.g.dart';

@freezed
class CompanyModel with _$CompanyModel {
  const factory CompanyModel({
    required String id,
    required String name,
    String? description,
    required String phone,
    required String categoryId,
    CategoryModel? category,
    String? city,
    String? state,
    String? address,
    @Default(true) bool isActive,
    String? whatsappUrl,
  }) = _CompanyModel;

  factory CompanyModel.fromJson(Map<String, dynamic> json) =>
      _$CompanyModelFromJson(json);
}
