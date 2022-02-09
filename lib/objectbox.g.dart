// GENERATED CODE - DO NOT MODIFY BY HAND

// ignore_for_file: camel_case_types

import 'dart:typed_data';

import 'package:objectbox/flatbuffers/flat_buffers.dart' as fb;
import 'package:objectbox/internal.dart'; // generated code can access "internal" functionality
import 'package:objectbox/objectbox.dart';
import 'package:objectbox_flutter_libs/objectbox_flutter_libs.dart';

import 'PointInfo.dart';

export 'package:objectbox/objectbox.dart'; // so that callers only have to import this file

final _entities = <ModelEntity>[
  ModelEntity(
      id: const IdUid(1, 1073044420471223774),
      name: 'PointInfo',
      lastPropertyId: const IdUid(6, 1800773113186925871),
      flags: 0,
      properties: <ModelProperty>[
        ModelProperty(
            id: const IdUid(1, 466148513180786633),
            name: 'id',
            type: 6,
            flags: 1),
        ModelProperty(
            id: const IdUid(2, 6697879009931089107),
            name: 'const_id',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(3, 4610328518991224389),
            name: 'x',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(4, 5214495079519302878),
            name: 'y',
            type: 8,
            flags: 0),
        ModelProperty(
            id: const IdUid(5, 2910780329916535122),
            name: 'date',
            type: 9,
            flags: 0),
        ModelProperty(
            id: const IdUid(6, 1800773113186925871),
            name: 'hour',
            type: 9,
            flags: 0)
      ],
      relations: <ModelRelation>[],
      backlinks: <ModelBacklink>[])
];

/// Open an ObjectBox store with the model declared in this file.
Future<Store> openStore(
        {String? directory,
        int? maxDBSizeInKB,
        int? fileMode,
        int? maxReaders,
        bool queriesCaseSensitiveDefault = true,
        String? macosApplicationGroup}) async =>
    Store(getObjectBoxModel(),
        directory: directory ?? (await defaultStoreDirectory()).path,
        maxDBSizeInKB: maxDBSizeInKB,
        fileMode: fileMode,
        maxReaders: maxReaders,
        queriesCaseSensitiveDefault: queriesCaseSensitiveDefault,
        macosApplicationGroup: macosApplicationGroup);

/// ObjectBox model definition, pass it to [Store] - Store(getObjectBoxModel())
ModelDefinition getObjectBoxModel() {
  final model = ModelInfo(
      entities: _entities,
      lastEntityId: const IdUid(1, 1073044420471223774),
      lastIndexId: const IdUid(0, 0),
      lastRelationId: const IdUid(0, 0),
      lastSequenceId: const IdUid(0, 0),
      retiredEntityUids: const [],
      retiredIndexUids: const [],
      retiredPropertyUids: const [],
      retiredRelationUids: const [],
      modelVersion: 5,
      modelVersionParserMinimum: 5,
      version: 1);

  final bindings = <Type, EntityDefinition>{
    PointInfo: EntityDefinition<PointInfo>(
        model: _entities[0],
        toOneRelations: (PointInfo object) => [],
        toManyRelations: (PointInfo object) => {},
        getId: (PointInfo object) => object.id,
        setId: (PointInfo object, int id) {
          object.id = id;
        },
        objectToFB: (PointInfo object, fb.Builder fbb) {
          final const_idOffset = object.const_id == null
              ? null
              : fbb.writeString(object.const_id!);
          final dateOffset =
              object.date == null ? null : fbb.writeString(object.date!);
          final hourOffset =
              object.hour == null ? null : fbb.writeString(object.hour!);
          fbb.startTable(7);
          fbb.addInt64(0, object.id);
          fbb.addOffset(1, const_idOffset);
          fbb.addFloat64(2, object.x);
          fbb.addFloat64(3, object.y);
          fbb.addOffset(4, dateOffset);
          fbb.addOffset(5, hourOffset);
          fbb.finish(fbb.endTable());
          return object.id;
        },
        objectFromFB: (Store store, ByteData fbData) {
          final buffer = fb.BufferContext(fbData);
          final rootOffset = buffer.derefObject(0);

          final object = PointInfo(
              id: const fb.Int64Reader().vTableGet(buffer, rootOffset, 4, 0))
            ..const_id =
                const fb.StringReader().vTableGetNullable(buffer, rootOffset, 6)
            ..x = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 8)
            ..y = const fb.Float64Reader()
                .vTableGetNullable(buffer, rootOffset, 10)
            ..date = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 12)
            ..hour = const fb.StringReader()
                .vTableGetNullable(buffer, rootOffset, 14);

          return object;
        })
  };

  return ModelDefinition(model, bindings);
}

/// [PointInfo] entity fields to define ObjectBox queries.
class PointInfo_ {
  /// see [PointInfo.id]
  static final id = QueryIntegerProperty<PointInfo>(_entities[0].properties[0]);

  /// see [PointInfo.const_id]
  static final const_id =
      QueryStringProperty<PointInfo>(_entities[0].properties[1]);

  /// see [PointInfo.x]
  static final x = QueryDoubleProperty<PointInfo>(_entities[0].properties[2]);

  /// see [PointInfo.y]
  static final y = QueryDoubleProperty<PointInfo>(_entities[0].properties[3]);

  /// see [PointInfo.date]
  static final date =
      QueryStringProperty<PointInfo>(_entities[0].properties[4]);

  /// see [PointInfo.hour]
  static final hour =
      QueryStringProperty<PointInfo>(_entities[0].properties[5]);
}
