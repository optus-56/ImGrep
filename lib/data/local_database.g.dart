// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_database.dart';

// ignore_for_file: type=lint
class $ImageMetasTable extends ImageMetas
    with TableInfo<$ImageMetasTable, ImageMeta> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ImageMetasTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _pathMeta = const VerificationMeta('path');
  @override
  late final GeneratedColumn<String> path = GeneratedColumn<String>(
    'path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modifiedMeta = const VerificationMeta(
    'modified',
  );
  @override
  late final GeneratedColumn<DateTime> modified = GeneratedColumn<DateTime>(
    'modified',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, path, modified];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'image_metas';
  @override
  VerificationContext validateIntegrity(
    Insertable<ImageMeta> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('path')) {
      context.handle(
        _pathMeta,
        path.isAcceptableOrUnknown(data['path']!, _pathMeta),
      );
    } else if (isInserting) {
      context.missing(_pathMeta);
    }
    if (data.containsKey('modified')) {
      context.handle(
        _modifiedMeta,
        modified.isAcceptableOrUnknown(data['modified']!, _modifiedMeta),
      );
    } else if (isInserting) {
      context.missing(_modifiedMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ImageMeta map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ImageMeta(
      id:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}id'],
          )!,
      path:
          attachedDatabase.typeMapping.read(
            DriftSqlType.string,
            data['${effectivePrefix}path'],
          )!,
      modified:
          attachedDatabase.typeMapping.read(
            DriftSqlType.dateTime,
            data['${effectivePrefix}modified'],
          )!,
    );
  }

  @override
  $ImageMetasTable createAlias(String alias) {
    return $ImageMetasTable(attachedDatabase, alias);
  }
}

class ImageMeta extends DataClass implements Insertable<ImageMeta> {
  final String id;
  final String path;
  final DateTime modified;
  const ImageMeta({
    required this.id,
    required this.path,
    required this.modified,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['path'] = Variable<String>(path);
    map['modified'] = Variable<DateTime>(modified);
    return map;
  }

  ImageMetasCompanion toCompanion(bool nullToAbsent) {
    return ImageMetasCompanion(
      id: Value(id),
      path: Value(path),
      modified: Value(modified),
    );
  }

  factory ImageMeta.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ImageMeta(
      id: serializer.fromJson<String>(json['id']),
      path: serializer.fromJson<String>(json['path']),
      modified: serializer.fromJson<DateTime>(json['modified']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'path': serializer.toJson<String>(path),
      'modified': serializer.toJson<DateTime>(modified),
    };
  }

  ImageMeta copyWith({String? id, String? path, DateTime? modified}) =>
      ImageMeta(
        id: id ?? this.id,
        path: path ?? this.path,
        modified: modified ?? this.modified,
      );
  ImageMeta copyWithCompanion(ImageMetasCompanion data) {
    return ImageMeta(
      id: data.id.present ? data.id.value : this.id,
      path: data.path.present ? data.path.value : this.path,
      modified: data.modified.present ? data.modified.value : this.modified,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ImageMeta(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('modified: $modified')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, path, modified);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ImageMeta &&
          other.id == this.id &&
          other.path == this.path &&
          other.modified == this.modified);
}

class ImageMetasCompanion extends UpdateCompanion<ImageMeta> {
  final Value<String> id;
  final Value<String> path;
  final Value<DateTime> modified;
  final Value<int> rowid;
  const ImageMetasCompanion({
    this.id = const Value.absent(),
    this.path = const Value.absent(),
    this.modified = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ImageMetasCompanion.insert({
    required String id,
    required String path,
    required DateTime modified,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       path = Value(path),
       modified = Value(modified);
  static Insertable<ImageMeta> custom({
    Expression<String>? id,
    Expression<String>? path,
    Expression<DateTime>? modified,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (path != null) 'path': path,
      if (modified != null) 'modified': modified,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ImageMetasCompanion copyWith({
    Value<String>? id,
    Value<String>? path,
    Value<DateTime>? modified,
    Value<int>? rowid,
  }) {
    return ImageMetasCompanion(
      id: id ?? this.id,
      path: path ?? this.path,
      modified: modified ?? this.modified,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (path.present) {
      map['path'] = Variable<String>(path.value);
    }
    if (modified.present) {
      map['modified'] = Variable<DateTime>(modified.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ImageMetasCompanion(')
          ..write('id: $id, ')
          ..write('path: $path, ')
          ..write('modified: $modified, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$LocalDatabase extends GeneratedDatabase {
  _$LocalDatabase(QueryExecutor e) : super(e);
  $LocalDatabaseManager get managers => $LocalDatabaseManager(this);
  late final $ImageMetasTable imageMetas = $ImageMetasTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [imageMetas];
}

typedef $$ImageMetasTableCreateCompanionBuilder =
    ImageMetasCompanion Function({
      required String id,
      required String path,
      required DateTime modified,
      Value<int> rowid,
    });
typedef $$ImageMetasTableUpdateCompanionBuilder =
    ImageMetasCompanion Function({
      Value<String> id,
      Value<String> path,
      Value<DateTime> modified,
      Value<int> rowid,
    });

class $$ImageMetasTableFilterComposer
    extends Composer<_$LocalDatabase, $ImageMetasTable> {
  $$ImageMetasTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ImageMetasTableOrderingComposer
    extends Composer<_$LocalDatabase, $ImageMetasTable> {
  $$ImageMetasTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get path => $composableBuilder(
    column: $table.path,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get modified => $composableBuilder(
    column: $table.modified,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ImageMetasTableAnnotationComposer
    extends Composer<_$LocalDatabase, $ImageMetasTable> {
  $$ImageMetasTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get path =>
      $composableBuilder(column: $table.path, builder: (column) => column);

  GeneratedColumn<DateTime> get modified =>
      $composableBuilder(column: $table.modified, builder: (column) => column);
}

class $$ImageMetasTableTableManager
    extends
        RootTableManager<
          _$LocalDatabase,
          $ImageMetasTable,
          ImageMeta,
          $$ImageMetasTableFilterComposer,
          $$ImageMetasTableOrderingComposer,
          $$ImageMetasTableAnnotationComposer,
          $$ImageMetasTableCreateCompanionBuilder,
          $$ImageMetasTableUpdateCompanionBuilder,
          (
            ImageMeta,
            BaseReferences<_$LocalDatabase, $ImageMetasTable, ImageMeta>,
          ),
          ImageMeta,
          PrefetchHooks Function()
        > {
  $$ImageMetasTableTableManager(_$LocalDatabase db, $ImageMetasTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer:
              () => $$ImageMetasTableFilterComposer($db: db, $table: table),
          createOrderingComposer:
              () => $$ImageMetasTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer:
              () => $$ImageMetasTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> path = const Value.absent(),
                Value<DateTime> modified = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ImageMetasCompanion(
                id: id,
                path: path,
                modified: modified,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String path,
                required DateTime modified,
                Value<int> rowid = const Value.absent(),
              }) => ImageMetasCompanion.insert(
                id: id,
                path: path,
                modified: modified,
                rowid: rowid,
              ),
          withReferenceMapper:
              (p0) =>
                  p0
                      .map(
                        (e) => (
                          e.readTable(table),
                          BaseReferences(db, table, e),
                        ),
                      )
                      .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ImageMetasTableProcessedTableManager =
    ProcessedTableManager<
      _$LocalDatabase,
      $ImageMetasTable,
      ImageMeta,
      $$ImageMetasTableFilterComposer,
      $$ImageMetasTableOrderingComposer,
      $$ImageMetasTableAnnotationComposer,
      $$ImageMetasTableCreateCompanionBuilder,
      $$ImageMetasTableUpdateCompanionBuilder,
      (ImageMeta, BaseReferences<_$LocalDatabase, $ImageMetasTable, ImageMeta>),
      ImageMeta,
      PrefetchHooks Function()
    >;

class $LocalDatabaseManager {
  final _$LocalDatabase _db;
  $LocalDatabaseManager(this._db);
  $$ImageMetasTableTableManager get imageMetas =>
      $$ImageMetasTableTableManager(_db, _db.imageMetas);
}
