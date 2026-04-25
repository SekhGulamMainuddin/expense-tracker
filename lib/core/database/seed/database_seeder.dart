import 'dart:math';
import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';
import 'package:expense_tracker/core/domain/entities/app_theme.dart';

class DatabaseSeeder {
  static Future<void> seed(AppDatabase db) async {
    final random = Random();

    // 1. Clear existing data
    await db.batch((batch) {
      batch.deleteWhere(db.expenses, (_) => const Constant(true));
      batch.deleteWhere(db.categories, (_) => const Constant(true));
      batch.deleteWhere(db.keyValueStore, (_) => const Constant(true));
    });

    // 2. Insert mock settings
    await db.batch((batch) {
      void setVal(String k, dynamic v) {
        batch.insert(
          db.keyValueStore,
          KeyValueStoreCompanion.insert(
            key: k,
            value: v.toString(),
          ),
          mode: InsertMode.insertOrReplace,
        );
      }

      setVal('baseCurrency', Currency.inr.name);
      setVal('dailyLimit', 1000.0);
      setVal('weeklyLimit', 7000.0);
      setVal('monthlyLimit', 30000.0);
      setVal('safeThreshold', 10.0);
      setVal('cautionThreshold', 15.0);
      setVal('dangerThreshold', 25.0);
      setVal('themeMode', AppTheme.system.name);
    });

    // 3. Define Categories
    final categoryTemplates = [
      {
        'title': 'Food',
        'icon': 'restaurant',
        'color': 0xFFFF5722,
        'children': [
          {'title': 'Groceries', 'icon': 'shopping_cart', 'color': 0xFF4CAF50},
          {'title': 'Dining Out', 'icon': 'restaurant_menu', 'color': 0xFFFF9800},
          {'title': 'Coffee', 'icon': 'coffee', 'color': 0xFF795548},
        ]
      },
      {
        'title': 'Transport',
        'icon': 'directions_car',
        'color': 0xFF2196F3,
        'children': [
          {'title': 'Fuel', 'icon': 'local_gas_station', 'color': 0xFFF44336},
          {'title': 'Public Transport', 'icon': 'directions_bus', 'color': 0xFF009688},
          {'title': 'Parking', 'icon': 'local_parking', 'color': 0xFF607D8B},
        ]
      },
      {
        'title': 'Entertainment',
        'icon': 'movie',
        'color': 0xFF9C27B0,
        'children': [
          {'title': 'Streaming', 'icon': 'play_circle', 'color': 0xFFE91E63},
          {'title': 'Games', 'icon': 'videogame_asset', 'color': 0xFF673AB7},
          {'title': 'Events', 'icon': 'event', 'color': 0xFF3F51B5},
        ]
      },
      {
        'title': 'Utilities',
        'icon': 'bolt',
        'color': 0xFFFFEB3B,
        'children': [
          {'title': 'Electricity', 'icon': 'electric_bolt', 'color': 0xFFFFC107},
          {'title': 'Water', 'icon': 'water_drop', 'color': 0xFF03A9F4},
          {'title': 'Internet', 'icon': 'wifi', 'color': 0xFF00BCD4},
        ]
      },
      {
        'title': 'Health',
        'icon': 'medical_services',
        'color': 0xFFE91E63,
        'children': [
          {'title': 'Medicine', 'icon': 'medication', 'color': 0xFFF06292},
          {'title': 'Gym', 'icon': 'fitness_center', 'color': 0xFF4DB6AC},
        ]
      },
      {'title': 'Shopping', 'icon': 'shopping_bag', 'color': 0xFF00BCD4, 'children': []},
    ];

    final Map<int, List<int>> parentToChildren = {};
    final List<int> allLeafCategoryIds = [];

    // Insert categories
    for (final template in categoryTemplates) {
      final parentId = await db.into(db.categories).insert(
            CategoriesCompanion.insert(
              title: template['title'] as String,
              icon: template['icon'] as String,
              color: template['color'] as int,
            ),
          );

      final children = template['children'] as List;
      if (children.isEmpty) {
        allLeafCategoryIds.add(parentId);
      } else {
        final childIds = <int>[];
        for (final item in children) {
          final child = item as Map<String, dynamic>;
          final childId = await db.into(db.categories).insert(
                CategoriesCompanion.insert(
                  title: child['title'] as String,
                  icon: child['icon'] as String,
                  color: child['color'] as int,
                  parentId: Value(parentId),
                ),
              );
          childIds.add(childId);
          allLeafCategoryIds.add(childId);
        }
        parentToChildren[parentId] = childIds;
      }
    }

    // 3. Generate Transactions
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 365 * 3));
    final totalDays = now.difference(startDate).inDays;

    final List<ExpensesCompanion> allExpenses = [];
    final titles = [
      'Weekly Groceries', 'Late Night Snack', 'Morning Coffee', 'Gas Station',
      'Uber Ride', 'Netflix Subscription', 'Gym Membership', 'Internet Bill',
      'Pharmacy', 'New Shoes', 'Movie Ticket', 'Dinner with Friends',
      'Lunch at Work', 'Bus Fare', 'Steam Game', 'Amazon Order',
      'Water Bill', 'Electricity Bill', 'Park Entrance', 'Pizza Delivery'
    ];

    for (int i = 0; i <= totalDays; i++) {
      final currentDate = startDate.add(Duration(days: i));
      // 4-12 transactions per day
      final dailyCount = random.nextInt(9) + 4;

      for (int j = 0; j < dailyCount; j++) {
        final categoryId = allLeafCategoryIds[random.nextInt(allLeafCategoryIds.length)];
        final amount = (random.nextDouble() * 1000 + 10).roundToDouble();
        
        // Randomly set title to null or a value
        final useTitle = random.nextDouble() > 0.3;
        final title = useTitle ? titles[random.nextInt(titles.length)] : null;
        
        // Add some variety to hours
        final txDate = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
          random.nextInt(24),
          random.nextInt(60),
        );

        allExpenses.add(
          ExpensesCompanion.insert(
            title: Value(title),
            amount: amount,
            baseAmount: Value(amount * Currency.inr.rateToInr),
            date: txDate,
            categoryId: categoryId,
            currency: const Value(Currency.inr),
          ),
        );
      }
      
      // Batch insert every 500 records to avoid memory issues
      if (allExpenses.length >= 500) {
        await db.batch((batch) {
          batch.insertAll(db.expenses, allExpenses);
        });
        allExpenses.clear();
      }
    }

    // Final batch
    if (allExpenses.isNotEmpty) {
      await db.batch((batch) {
        batch.insertAll(db.expenses, allExpenses);
      });
    }
  }
}
