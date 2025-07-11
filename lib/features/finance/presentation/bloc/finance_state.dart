import '../../domain/entities/finance.dart';

abstract class FinanceState {}

class FinanceInitial extends FinanceState {}

class FinanceLoading extends FinanceState {}

class FinanceLoaded extends FinanceState {
  final List<Finance> finances;
  FinanceLoaded(this.finances);
}

class FinanceError extends FinanceState {
  final String message;
  FinanceError(this.message);
}
