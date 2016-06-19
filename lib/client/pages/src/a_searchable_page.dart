part of pages;


abstract class ASearchablePage {
  bool showSearch = true;

  Future search(String query);
}