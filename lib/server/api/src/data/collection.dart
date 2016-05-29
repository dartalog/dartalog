part of api;

class Collection extends AIdData {
  Collection();

  Future _getById(String id) => model.itemCollections.getById(id);
}
