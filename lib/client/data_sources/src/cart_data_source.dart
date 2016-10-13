import 'dart:async';
import 'dart:indexed_db' as idb;

import 'package:dartalog/client/data/data.dart';

import 'a_data_source.dart';

class CartDataSource extends ADataSource {
  Future<List<ItemCopy>> getCart() async {
    return await wrapTransaction(
        ADataSource.DARTALOG_IDB_CART_STORE, ADataSource.READ_ONLY,
        (idb.ObjectStore store) async {

     Stream<idb.CursorWithValue> stream = store.openCursor(autoAdvance:true);
     List<ItemCopy> output = [];
     await stream.forEach((idb.CursorWithValue cursor) {
       Map value = cursor.value;
     output.add(new ItemCopy.forItem(value["itemId"], copy: value["copy"]));

     });

      return output;
    });
  }

  Future setCart(List<ItemCopy> cart) async {
    await wrapTransaction(
        ADataSource.DARTALOG_IDB_CART_STORE, ADataSource.READ_WRITE,
        (idb.ObjectStore store) async {
          await store.clear();
          for(ItemCopy itemCopy in cart) {
            await store.put({"itemId": itemCopy.itemId, "copy": itemCopy.copy});
          }
    });
  }

  Future clearCart(List<ItemCopy> cart) async {
    await wrapTransaction(
        ADataSource.DARTALOG_IDB_CART_STORE, ADataSource.READ_WRITE,
        (idb.ObjectStore store) async {
      await store.clear();
    });
  }
}

