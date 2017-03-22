import 'dart:async';
import 'dart:indexed_db' as idb;

import 'package:dartalog/client/api/api.dart';

import 'a_data_source.dart';
import 'package:angular2/core.dart';

@Injectable()
class CartService extends ADataSource {
  Future<List<ItemCopy>> getCart() async {
    return await wrapTransaction(
        ADataSource.idbCartStore, ADataSource.readOnlyPermission,
        (idb.ObjectStore store) async {
      final Stream<idb.CursorWithValue> stream =
          store.openCursor(autoAdvance: true);
      final List<ItemCopy> output = <ItemCopy>[];
      await stream.forEach((idb.CursorWithValue cursor) {
        final Map<String, dynamic> value = cursor.value;
        final ItemCopy ic = new ItemCopy();
        ic.itemId = value["itemId"];
        ic.copy = value["copy"];
        output.add(ic);
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
