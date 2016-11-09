import 'package:polymer/polymer.dart';
import 'item_copy.dart';
import 'package:dartalog/tools.dart';

class CartItem extends ItemCopy {
  @property
  String get cartId => "cartItem${itemId}${copy}";

  @Property(notify: true)
  String errorMessage = StringTools.empty;

  CartItem.copyFrom(dynamic input) : super.copyFrom(input);
}
