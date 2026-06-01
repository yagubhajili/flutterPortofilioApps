import 'package:equatable/equatable.dart';

class Video extends Equatable {
  final String id;
  final String key;
  final String name;
  final String site;
  final String type;
  final bool official;

  const Video({
    required this.id,
    required this.key,
    required this.name,
    required this.site,
    required this.type,
    this.official = false,
  });

  bool get isYoutube => site == 'YouTube';
  bool get isTrailer => type == 'Trailer';

  @override
  List<Object> get props => [id];
}
