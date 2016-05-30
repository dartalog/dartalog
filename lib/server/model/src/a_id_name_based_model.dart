part of model;

abstract class AIdNameBasedModel<T extends AIdData> extends AModel {
  data_sources.AIdNameBasedDataSource<T> get dataSource;

  Future<String> create(T t) async {
    await validate(t, true);
    return await dataSource.write(t);
  }

  Future delete(String id) => dataSource.delete(id);

  Future<List<IdNamePair>> getAllIdsAndNames() =>
      dataSource.getAllIdsAndNames();

  Future<List<T>> getAll() =>
      dataSource.getAll();

  Future<T> getById(String id) async {
    T output = await dataSource.getById(id);
    if (output == null) throw new NotFoundException("ID '${id}' not found");

    return output;
  }

  Future<String> update(String id, T t) async {
    await validate(t, id != t.id);
    return await dataSource.write(t, id);
  }

  Future _validateFields(T t, bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    t.id = t.id.trim().toLowerCase();
    t.name = t.name.trim();

    if (isNullOrWhitespace(t.id))
      field_errors["id"] = "Required";
    else {
      if (creating) {
        dynamic other = await getById(t.id);
        if (other != null) field_errors["id"] = "Already in use";
      }
      if (RESERVED_WORDS.contains(t.id.trim().toLowerCase())) {
        field_errors["id"] = "Cannot use '${t.id}' as ID";
      }
    }

    if (isNullOrWhitespace(t.name)) {
      field_errors["name"] = "Required";
    } else if (RESERVED_WORDS.contains(t.id.trim().toLowerCase())) {
      field_errors["name"] = "Cannot use '${t.name}' as name";
    }

    field_errors.addAll(await _validateFieldsInternal(t));

    return field_errors;
  }

  Future<Map<String, String>> _validateFieldsInternal(T t) async => {};
}
