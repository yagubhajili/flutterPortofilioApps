import '../../domain/entities/cast_member.dart';

class CastModel extends CastMember {
  const CastModel({
    required super.id,
    required super.name,
    super.character,
    super.profilePath,
    super.order,
  });

  factory CastModel.fromJson(Map<String, dynamic> json) => CastModel(
        id: json['id'] as int,
        name: json['name'] as String,
        character: json['character'] as String?,
        profilePath: json['profile_path'] as String?,
        order: json['order'] as int?,
      );
}
