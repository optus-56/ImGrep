import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'image_meta_table.dart';

part 'local_database.g.dart'; // if missing build this part by `dart run build_runner build`

@DriftDatabase(tables: [ImageMetas])
class LocalDatabase extends _$LocalDatabase {
  LocalDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<ImageMeta>> getAllMetas() => select(imageMetas).get();

  Future<ImageMeta?> getMetaById(String id) =>
      (select(imageMetas)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();

  Future<void> insertOrUpdate(ImageMeta meta) =>
      into(imageMetas).insertOnConflictUpdate(meta);

  Future<void> deleteById(String id) =>
      (delete(imageMetas)..where((tbl) => tbl.id.equals(id))).go();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = p.join(dir.path, 'image_meta.sqlite');
    return NativeDatabase(File(dbPath));
  });
}
