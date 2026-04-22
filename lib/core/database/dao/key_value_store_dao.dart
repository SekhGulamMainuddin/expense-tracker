import 'dart:convert';
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/key_value_store_table.dart';

part 'key_value_store_dao.g.dart';

@DriftAccessor(tables: [KeyValueStore])
class KeyValueStoreDao extends DatabaseAccessor<AppDatabase> with _$KeyValueStoreDaoMixin {
  KeyValueStoreDao(super.db);

  /// Stores any JSON-compatible value (bool, int, double, String, Map).
  Future<void> setValue<T>(String key, T value) async {
    final encodedValue = jsonEncode(value);
    await into(keyValueStore).insert(
      KeyValueStoreCompanion.insert(
        key: key,
        value: encodedValue,
      ),
      mode: InsertMode.insertOrReplace,
    );
  }

  /// Retrieves a value and casts it to the expected type [T].
  /// Returns [defaultValue] if the key does not exist or fails to decode.
  Future<T?> getValue<T>(String key, {T? defaultValue}) async {
    final query = select(keyValueStore)..where((t) => t.key.equals(key));
    final entry = await query.getSingleOrNull();

    if (entry == null) return defaultValue;

    try {
      return jsonDecode(entry.value) as T?;
    } catch (e) {
      return defaultValue;
    }
  }

  /// Watches a value for reactive UI updates.
  Stream<T?> watchValue<T>(String key, {T? defaultValue}) {
    final query = select(keyValueStore)..where((t) => t.key.equals(key));

    return query.watchSingleOrNull().map((entry) {
      if (entry == null) return defaultValue;
      try {
        return jsonDecode(entry.value) as T?;
      } catch (e) {
        return defaultValue;
      }
    });
  }

  /// Watches the entire table for any changes.
  Stream<List<KeyValueStoreData>> watchAllEntries() => select(keyValueStore).watch();

  Future<void> deleteKey(String key) =>
      (delete(keyValueStore)..where((t) => t.key.equals(key))).go();
}