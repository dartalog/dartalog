part of model;

abstract class AIdNameBasedModel<T extends AIdData> extends AModel {
  AIdNameBasedDataSource<T> get dataSource;

  Future<List<T>> search(String query) => dataSource.search(query);

  Future<String> create(T t) async {
//    if (!userAuthenticated()) {
//      throw new NotAuthorizedException();
//    }
    await validate(t, true);
    return await dataSource.write(t);
  }

  Future delete(String id) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }

    await dataSource.delete(id);
  }

  Future<List<IdNamePair>> getAllIdsAndNames() =>
      dataSource.getAllIdsAndNames();

  Future<List<T>> getAll() async {
    List<T> output = await dataSource.getAll();
    for (T t in output) _performAdjustments(t);
    return output;
  }

  Future<T> getById(String id) async {
    Option<T> output = await dataSource.getById(id);

    if (output.isEmpty) throw new NotFoundException("ID '${id}' not found");

    _performAdjustments(output.get());

    return output.get();
  }

  _performAdjustments(T t) {}

  Future<String> update(String id, T t) async {
    if (!userAuthenticated()) {
      throw new NotAuthorizedException();
    }
    await validate(t, id != t.getId);
    return await dataSource.write(t, id);
  }

  @override
  Future<Map<String, String>> _validateFields(T t, bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    t.getId = t.getId.trim().toLowerCase();
    t.getName = t.getName.trim();

    if (isNullOrWhitespace(t.getId))
      field_errors["id"] = "Required";
    else {
      if (creating) {
        if (await dataSource.exists(t.getId))
          field_errors["id"] = "Already in use";
      }
      if (RESERVED_WORDS.contains(t.getId.trim().toLowerCase())) {
        field_errors["id"] = "Cannot use '${t.getId}' as ID";
      }
    }

    if (isNullOrWhitespace(t.getName)) {
      field_errors["name"] = "Required";
    } else if (RESERVED_WORDS.contains(t.getId.trim().toLowerCase())) {
      field_errors["name"] = "Cannot use '${t.getName}' as name";
    }

    await _validateFieldsInternal(field_errors, t, creating);

    return field_errors;
  }

  Future _validateFieldsInternal(Map field_errors, T t, bool creating) async => {};
}
