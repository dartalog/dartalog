part of pages;


abstract class ADeletablePage {
  bool showDeleteButton = true;

  Future delete();
}