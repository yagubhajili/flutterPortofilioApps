import 'package:equatable/equatable.dart';
import '../../../domain/entities/person_detail.dart';

abstract class PersonState extends Equatable {
  const PersonState();
  @override
  List<Object?> get props => [];
}

class PersonInitial extends PersonState {}
class PersonLoading extends PersonState {}

class PersonLoaded extends PersonState {
  final PersonDetail person;
  const PersonLoaded(this.person);
  @override
  List<Object?> get props => [person];
}

class PersonError extends PersonState {
  final String message;
  const PersonError(this.message);
  @override
  List<Object?> get props => [message];
}
