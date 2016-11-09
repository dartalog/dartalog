// Copyright (c) 2015, Matthew Barbour. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

@HtmlImport("checkout_control.html")
library dartalog.client.pages.checkout_control;

import 'dart:convert';
import 'dart:async';
import 'dart:html';

import 'package:dartalog/client/client.dart';
import 'package:dartalog/client/controls/controls.dart';
import 'package:dartalog/client/data/data.dart';
import 'package:dartalog/client/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/global.dart';
import 'package:logging/logging.dart';
import 'package:option/option.dart';
import 'package:polymer/polymer.dart';
import 'package:dartalog/client/api/api.dart' as API;
import 'package:dartalog/tools.dart';

/// Make [IronImage] available
import 'package:polymer_elements/iron_image.dart';

/// Make [PaperButton] available
import 'package:polymer_elements/paper_button.dart';
import 'package:polymer_elements/paper_dialog.dart';

/// Make [PaperDialogScrollable] available
import 'package:polymer_elements/paper_dialog_scrollable.dart';

/// Make [PaperDropdownMenu] available
import 'package:polymer_elements/paper_dropdown_menu.dart';

/// Make [PaperIconButton] available
import 'package:polymer_elements/paper_icon_button.dart';

/// Make [PaperListbox] available
import 'package:polymer_elements/paper_listbox.dart';
import 'package:web_components/web_components.dart';

@PolymerRegister('checkout-control')
class CheckoutControl extends AControl {
  static final Logger _log = new Logger("CheckoutPage");
  static const String CART_IS_EMPTY = "cartIsEmpty";

  @Property(notify: true)
  List<IdNamePair> users = new List<IdNamePair>();

  @property
  bool cartIsEmpty = false;

  @property
  bool showCheckoutButton = false;

  @Property(notify: true)
  String checkoutUser = "";

  @Property(notify: true)
  List<CartItem> cart = new List<CartItem>();

  CheckoutControl.created() : super.created();

  Logger get loggerImpl => _log;

  Future addToCart(ItemCopy itemCopy) async {
    for (ItemCopy test in this.cart) {
      if (itemCopy.matchesItemCopy(test)) return;
    }
    add("cart", new CartItem.copyFrom(itemCopy));
    data_sources.cart.setCart(this.cart);
    _evaluateCart();
  }

  attached() {
    super.attached();
  }

  bool checkCartFor(ItemCopy itemCopy) =>
      _getItemCopy(itemCopy.itemId, itemCopy.copy).isNotEmpty;

  @reflectable
  Future checkoutClicked(event, [_]) async {
    await handleApiExceptions(() async {
      API.BulkItemActionRequest request = new API.BulkItemActionRequest();
      request.actionerUserId = this.checkoutUser;
      request.action = ItemAction.borrow;
      request.itemCopies = new List<API.ItemCopyId>();
      for (CartItem item in this.cart) {
        API.ItemCopyId id = new API.ItemCopyId();
        id.copy = item.copy;
        id.itemId = item.itemId;
        request.itemCopies.add(id);
      }
      await API.item.items.copies.performBulkAction(request);

      this.close();
      clear("cart");
      await data_sources.cart.setCart(this.cart);
      await this.refreshCartInfo();
      await this.refreshActivePage();
      set("checkoutUser", StringTools.empty);
      showMessage("Checkout complete");
    });
  }

  @override
  bool handleErrorDetail(ApiRequestErrorDetail detail) {
    if (detail.locationType == "itemCopy") {
      Map<String, dynamic> data = JSON.decode(detail.location);
      for (CartItem item in this.cart) {
        if (item.matches(data["itemId"], data["copy"])) {
          set("cart.${this.cart.indexOf(item)}.errorMessage", detail.message);
          return true;
        }
      }
    }
    return super.handleErrorDetail(detail);
  }

  Future open() async {
    PaperDialog pd = this.querySelector("paper-dialog");
    await this.refresh();
    this.openDialog(pd);
  }

  Future close() async {
    PaperDialog pd = this.querySelector("paper-dialog");
    pd.close();
  }

  Future refresh() async {
    await handleApiExceptions(() async {
      clear("users");
      API.ListOfIdNamePair users = await API.item.users.getAllIdsAndNames();
      addAll("users", IdNamePair.copyList(users));

      List<CartItem> newCart = <CartItem>[];

      List<ItemCopy> freshCart = await data_sources.cart.getCart();

      for (ItemCopy itemCopy in freshCart) {
        try {
          API.ItemCopy updatedItemCopy = await API.item.items.copies.get(
              itemCopy.itemId, itemCopy.copy,
              includeCollection: true, includeItemSummary: true);
          newCart.add(new CartItem.copyFrom(updatedItemCopy));
        } on API.DetailedApiRequestError catch (e) {
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
    await this.refreshCartInfo();
  }

  @reflectable
  removeClicked(event, [_]) async {
    try {
      Option<Element> oEle = getParentElement(event.target, "div");
      if (oEle.isEmpty) throw new Exception("Parent div not found");
      Element ele = oEle.get();
      String itemId = ele.dataset["item-id"];
      String itemCopy = ele.dataset["item-copy"];
      _getItemCopy(itemId, int.parse(itemCopy)).map((ItemCopy itemCopy) {
        removeItem("cart", itemCopy);
      });
      await data_sources.cart.setCart(this.cart);
      await this.refreshCartInfo();
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
    for (CartItem test in this.cart) {
      if (test.matches(itemID, copy)) return new Some<ItemCopy>(test);
    }
    return new None<ItemCopy>();
  }
}
