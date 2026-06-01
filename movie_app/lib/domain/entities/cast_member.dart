import 'package:equatable/equatable.dart';

class CastMember extends Equatable {
  final int id;
  final String name;
  final String? character;
  final String? profilePath;
  final int? order;

  const CastMember({
    required this.id,
    required this.name,
    this.character,
    this.profilePath,
    this.order,
  });

  @override
  List<Object?> get props => [id];
}
