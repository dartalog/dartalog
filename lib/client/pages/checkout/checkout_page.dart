// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("checkout_page.html")
library dartalog.client.pages.checkout_page;

import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/item_add/item_add_control.dart';
import 'package:dartalog/client/controls/auth_wrapper/auth_wrapper_control.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/pages/pages.dart';
import 'package:dartalog/dartalog.dart' as dartalog;
import 'package:dartalog/tools.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:polymer/polymer.dart';
import 'package:polymer_elements/iron_flex_layout.dart';
import 'package:polymer_elements/iron_icon.dart';
import 'package:polymer_elements/iron_image.dart';
import 'package:polymer_elements/iron_list.dart';
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_card.dart';
import 'package:polymer_elements/paper_dialog.dart';
import 'package:polymer_elements/paper_dialog_scrollable.dart';
import 'package:polymer_elements/paper_dropdown_menu.dart';
import 'package:polymer_elements/paper_fab.dart';
import 'package:polymer_elements/paper_icon_button.dart';
import 'package:polymer_elements/paper_input.dart';
import 'package:polymer_elements/paper_listbox.dart';
import 'package:web_components/web_components.dart';
import 'package:dartalog/client/api/dartalog.dart' as API;
import 'package:dartalog/client/data_sources/data_sources.dart' as data_sources;

@PolymerRegister('checkout-page')
class CheckoutPage extends APage with ARefreshablePage {
  static final Logger _log = new Logger("CheckoutPage");
  static const String CART_IS_EMPTY = "cartIsEmpty";

  @Property(notify: true)
  List<ItemCopy> cart = new List<ItemCopy>();

  @Property(notify: true)
  List<IdNamePair> users = new List<IdNamePair>();

  @property
  bool cartIsEmpty = false;

  @property
  bool showCheckoutButton = false;
  @Property(notify: true)
  String checkoutUser = "";

  AuthWrapperControl get authWrapper => this.querySelector("auth-wrapper-control");

  CheckoutPage.created() : super.created("Checkout");

  Logger get loggerImpl => _log;

  //This is called during app load, so make sure it can refresh without args
  @override
  Future activateInternal([bool forceRefresh = false]) async {
    if(authWrapper.evaluatePageAuthentication())
      await this.refresh();
  }

  Future addToCart(ItemCopy itemCopy) async {
    for (ItemCopy test in this.cart) {
      if (itemCopy.matchesItemCopy(test)) return;
    }
    add("cart", itemCopy);
    data_sources.cart.setCart(this.cart);
    _evaluateCart();
  }

  bool checkCartFor(ItemCopy itemCopy) {
    _getItemCopy(itemCopy.itemId, itemCopy.copy).isNotEmpty;
  }

  Future checkoutClicked(event, [_]) async {
    await handleApiExceptions(() async {

    });
  }

  @override
  Future refresh() async {
    await handleApiExceptions(() async {
      clear("users");
      API.ListOfIdNamePair users = await this.api.users.getAllIdsAndNames();
      addAll("users", IdNamePair.copyList(users));

      List<ItemCopy> newCart = [];

      List<ItemCopy> freshCart = await data_sources.cart.getCart();

      for (ItemCopy itemCopy in freshCart) {
        try {
          API.ItemCopy updatedItemCopy =
              await api.items.copies.get(itemCopy.itemId, itemCopy.copy, includeCollection: true, includeItemSummary: true);
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
    this.mainApp.refreshCartInfo();
  }

  @reflectable
  removeClicked(event, [_]) async {
    try {
      Element ele = getParentElement(event.target, "div");
      String itemId = ele.dataset["item-id"];
      String itemCopy = ele.dataset["item-copy"];
      _getItemCopy(itemId, int.parse(itemCopy)).map((ItemCopy itemCopy) {
        removeItem("cart", itemCopy);
      });
      await data_sources.cart.setCart(this.cart);
      this.mainApp.refreshCartInfo();
    } catch (e, st) {
      handleException(e, st);
    }
    _evaluateCart();
  }

  void _evaluateCart() {
    set("showCheckoutButton", cart.isNotEmpty);
    set(CART_IS_EMPTY, cart.isEmpty);
  }

  Option<ItemCopy> _getItemCopy(String itemID, int copy) {
    for (ItemCopy test in this.cart) {
      if (test.matches(itemID, copy)) return new Some(test);
    }
    return new None();
  }
}
