import 'package:equatable/equatable.dart';

abstract class FavoritesEvent extends Equatable {
  const FavoritesEvent();
  @override
  List<Object?> get props => [];
}

class LoadFavoritesEvent extends FavoritesEvent {
  const LoadFavoritesEvent();
}

class ToggleFavoriteEvent extends FavoritesEvent {
  final String cca3;
  const ToggleFavoriteEvent(this.cca3);
  @override
  List<Object?> get props => [cca3];
}
