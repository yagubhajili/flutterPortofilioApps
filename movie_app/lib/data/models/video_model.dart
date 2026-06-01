import '../../domain/entities/video.dart';

class VideoModel extends Video {
  const VideoModel({
    required super.id,
    required super.key,
    required super.name,
    required super.site,
    required super.type,
    super.official,
  });

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json['id'] as String,
        key: json['key'] as String,
        name: json['name'] as String,
        site: json['site'] as String,
        type: json['type'] as String,
        official: json['official'] as bool? ?? false,
      );
}
