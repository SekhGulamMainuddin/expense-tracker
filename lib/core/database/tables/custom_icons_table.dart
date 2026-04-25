import 'package:drift/drift.dart';

class CustomIcons extends Table {
  IntColumn get id => integer().autoIncrement()();
  
  // Unique name provided by the user for identification
  TextColumn get name => text().unique().withLength(min: 1, max: 50)();
  
  // The URL path to the icon (could be local or network)
  TextColumn get iconUrl => text()();
  
  // Metadata for the icon (optional)
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
