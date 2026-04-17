import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:expense_tracker/features/home/presentation/cubit/finance_state.dart';

class FinanceCubit extends Cubit<FinanceState> {
  FinanceCubit()
      : super(
          const FinanceState(
            balance: 12450.80,
            income: 2400.00,
            expenses: 1120.50,
            transactions: [
              {
                'title': 'Grocery Store',
                'subtitle': 'Today, 2:45 PM',
                'amount': -64.20,
                'icon': 'shopping_bag',
                'color': 'emerald',
              },
              {
                'title': 'Uber Trip',
                'subtitle': 'Yesterday, 9:12 PM',
                'amount': -18.00,
                'icon': 'directions_car',
                'color': 'blue',
              },
              {
                'title': 'Salary Deposit',
                'subtitle': 'Oct 24, 2023',
                'amount': 3400.00,
                'icon': 'payments',
                'color': 'orange',
              },
            ],
          ),
        );

  void addTransaction() {
    // Logic to add a transaction would go here
  }
}
