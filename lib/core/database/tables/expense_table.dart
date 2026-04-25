import 'package:drift/drift.dart';
import 'package:expense_tracker/core/domain/entities/currency.dart';

@TableIndex(name: 'idx_expenses_date', columns: {#date})
@TableIndex(name: 'idx_expenses_category', columns: {#categoryId})
class Expenses extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Nullable because you want to handle the "Default to Category" logic in code
  TextColumn get title => text().nullable().withLength(max: 50)();

  RealColumn get amount => real()();

  DateTimeColumn get date => dateTime()();

  // Foreign Key to Categories
  IntColumn get categoryId => integer().references(Categories, #id)();
  // Use the map() function to attach the converter
  TextColumn get currency => text().map(const CurrencyConverter()).withDefault(const Constant('usd'))();
}

class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();

  TextColumn get title => text().withLength(min: 1, max: 50)();

  TextColumn get icon => text()(); // Store icon identifier or path
  IntColumn get color => integer()(); // Store color as an int (ARGB)

  // This defines the self-referencing hierarchy.
  // If parentId is null, it is a top-level category.
  IntColumn get parentId => integer().nullable().references(Categories, #id)();
}

class CurrencyConverter extends TypeConverter<Currency, String> {
  const CurrencyConverter();

  @override
  Currency fromSql(String fromDb) {
    return Currency.fromCode(fromDb);
  }

  @override
  String toSql(Currency value) {
    return value.name;
  }
}