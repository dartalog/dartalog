import 'package:option/option.dart';
import 'a_mongo_data_source.dart';
import 'a_mongo_object_data_source.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'dart:async';
import 'constants.dart';
import 'package:dartalog/server/data/data.dart';
import 'a_mongo_uuid_based_data_source.dart';
import 'package:dartalog/global.dart';
abstract class AMongoNestedObjectDataSource<T extends AUuidData,P extends AUuidData>
    extends AMongoDataSource {

  AMongoUuidBasedDataSource<P> get parentSource;

  Future<Null> iterateParentObjects(SelectorBuilder selector, Future<Null> toAwait(P item), {bool update: false}) async {
    final Stream<P> items = await parentSource.streamFromDb(selector);
    await items.forEach((P item) async {
      await toAwait(item);

      if(update) {
        final SelectorBuilder selector = where
            .eq(uuidField, item.uuid);
        await parentSource.genericUpdate(selector, item, multiUpdate: false);
      }
    });
  }

}