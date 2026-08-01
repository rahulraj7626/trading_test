import 'package:equatable/equatable.dart';

class Wallet extends Equatable {
  final double balance;

  const Wallet({required this.balance});

  Wallet copyWith({double? balance}) {
    return Wallet(balance: balance ?? this.balance);
  }

  @override
  List<Object?> get props => [balance];
}
