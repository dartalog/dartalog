import 'dart:async';
import 'package:polymer/polymer.dart';
import 'package:dartalog/tools.dart';
import 'a_searchable_page.dart';

abstract class ACollectionPage {
  @Property(notify: true)
  bool showAddButton = false;

  @Property(notify: true)
  int currentPage = 1;

  @Property(notify: true)
  int totalPages = 1;


  Future newItem();

  @reflectable
  bool isCurrentPage(int page) => page == currentPage;

  @reflectable
  String getPaginationLink(int page) {
    if(this is ASearchablePage) {
      ASearchablePage sp = this as ASearchablePage;
      if(isNullOrWhitespace(sp.searchQuery)) {
        return "items?page=${page}&search=${Uri.encodeQueryComponent(
            sp.searchQuery)}";
      }
    }
    return "items?page=${page}";
  }


}