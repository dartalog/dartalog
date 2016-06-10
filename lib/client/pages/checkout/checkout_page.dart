// Copyright (c) 2015, <your name>. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("checkout_page.html")
library dartalog.client.pages.checkout_page;

import 'dart:html';
import 'dart:async';
import 'package:logging/logging.dart';

import 'package:polymer/polymer.dart';
import 'package:option/option.dart';
import 'package:web_components/web_components.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:polymer_elements/iron_list.dart';
import 'package:polymer_elements/iron_flex_layout.dart';


import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/client/controls/item_add/item_add_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/client.dart';
import 'package:dartalog/tools.dart';

import '../../api/dartalog.dart' as API;

@PolymerRegister('checkout-page')
class CheckoutPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("CheckoutPage");
  Logger get loggerImpl => _log;

  @Property(notify: true)
  List<ItemCopy> cart = new List<ItemCopy>();

  CheckoutPage.created() : super.created("Checkout");

  static const String CART_IS_EMPTY = "cartIsEmpty";
  @property
  bool cartIsEmpty = false;

  @property
  bool showCheckoutButton = false;

  @reflectable
  removeClicked(event, [_]) {
    try {
      Element ele = getParentElement(event.target, "paper-item");
      String itemId = ele.dataset["item-id"];
      String itemCopy = ele.dataset["item-copy"];
      _getItemCopy(itemId, int.parse(itemCopy)).map((ItemCopy itemCopy) {
        removeItem("cart", itemCopy);
      });
    } catch(e,st) {
      handleException(e,st);
    }
    _evaluateCart();
  }

  @override
  Future activateInternal(Map args) async {
    await this.refresh();
  }

  @override
  Future refresh() async {
    await handleApiExceptions(() async {
      List<ItemCopy> newCart = [];
      for (ItemCopy itemCopy in cart) {
        try {
          API.ItemCopy updatedItemCopy = await api.items.copies.get(
              itemCopy.itemId, itemCopy.copy);
          newCart.add(new ItemCopy.copyFrom(updatedItemCopy));
        } on API.DetailedApiRequestError catch (e, st) {
          if (e.status == 404) {
            //TODO: More robust handling of item status changes
            showMessage("Item not found on server");
          } else {
            throw e;
          }
        }
      }
      clear("cart");
      addAll("cart", newCart);
      _evaluateCart();
    });
  }

  void _evaluateCart() {
    set("showCheckoutButton", cart.isNotEmpty);
    set(CART_IS_EMPTY, cart.isEmpty);
  }

  Option<ItemCopy> _getItemCopy(String itemID , int copy) {
    for (ItemCopy test in this.cart) {
      if (test.matches(itemID, copy))
        return new Some(test);
    }
    return new None();
  }

  bool checkCartFor(ItemCopy itemCopy) {
    _getItemCopy(itemCopy.itemId, itemCopy.copy).isNotEmpty;
  }

  void addToCart(ItemCopy itemCopy) {
    for(ItemCopy test in this.cart) {
      if(itemCopy.matchesItemCopy(test))
        return;
    }
    add("cart",itemCopy);
    _evaluateCart();
  }

  Future checkoutClicked(event,[_]) async {

  }

}