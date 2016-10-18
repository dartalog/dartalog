import 'dart:async';
import 'dart:indexed_db' as idb;

import 'package:dartalog/client/data/data.dart';

import 'a_data_source.dart';

class CartDataSource extends ADataSource {
  Future<List<ItemCopy>> getCart() async {
    return await wrapTransaction(
        ADataSource.idbCartStore, ADataSource.readOnlyPermission,
        (idb.ObjectStore store) async {
      final Stream<idb.CursorWithValue> stream =
          store.openCursor(autoAdvance: true);
      final List<ItemCopy> output = <ItemCopy>[];
      await stream.forEach((idb.CursorWithValue cursor) {
        final Map<String, dynamic> value = cursor.value;
        output.add(new ItemCopy.forItem(value["itemId"], copy: value["copy"]));
      });

      return output;
    });
  }

  Future<Null> setCart(List<ItemCopy> cart) async {
    await wrapTransaction(
        ADataSource.idbCartStore, ADataSource.readWritePermission,
        (idb.ObjectStore store) async {
      await store.clear();
      for (ItemCopy itemCopy in cart) {
        await store.put(<String, dynamic>{
          "itemId": itemCopy.itemId,
          "copy": itemCopy.copy
        });
      }
    });
  }

  Future<Null> clearCart(List<ItemCopy> cart) async {
    await wrapTransaction(
        ADataSource.idbCartStore, ADataSource.readWritePermission,
        (idb.ObjectStore store) async {
      await store.clear();
    });
  }
}
