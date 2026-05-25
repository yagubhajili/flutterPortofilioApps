import 'package:equatable/equatable.dart';

class CurrencyEntity extends Equatable {
  final String code;
  final String name;
  final String? symbol;

  const CurrencyEntity({
    required this.code,
    required this.name,
    this.symbol,
  });

  @override
  List<Object?> get props => [code, name, symbol];
}
