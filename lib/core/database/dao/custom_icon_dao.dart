import 'package:drift/drift.dart';
import 'package:expense_tracker/core/database/app_database.dart';
import 'package:expense_tracker/core/database/tables/custom_icons_table.dart';

part 'custom_icon_dao.g.dart';

@DriftAccessor(tables: [CustomIcons])
class CustomIconDao extends DatabaseAccessor<AppDatabase> with _$CustomIconDaoMixin {
  CustomIconDao(super.db);

  Future<List<CustomIcon>> getAllCustomIcons() => select(customIcons).get();

  Stream<List<CustomIcon>> watchAllCustomIcons() => select(customIcons).watch();

  Future<int> addCustomIcon(CustomIconsCompanion entry) =>
      into(customIcons).insert(entry, mode: InsertMode.insertOrReplace);

  Future<CustomIcon?> getCustomIconByName(String name) =>
      (select(customIcons)..where((t) => t.name.equals(name))).getSingleOrNull();

  Future<int> deleteCustomIcon(int id) =>
      (delete(customIcons)..where((t) => t.id.equals(id))).go();
}
