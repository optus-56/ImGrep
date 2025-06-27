import 'package:drift/drift.dart';

class ImageMetas extends Table {
  TextColumn get id => text()();
  TextColumn get path => text()();
  DateTimeColumn get modified => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}
