part of model;

abstract class AIdNameBasedModel<T extends AIdData> extends ATypedModel {
  AIdNameBasedDataSource<T> get dataSource;

  String _normalizeId(String input) {
    String output = input.trim().toLowerCase();
    output = Uri.decodeQueryComponent(output);
    return output;
  }

  Future<String> create(T t) async {
    await _validateCreatePrivileges();
    await validate(t, true);
    return await dataSource.write(t);
  }

  Future delete(String id) async {
    id = _normalizeId(id);
    await _validateDeletePrivileges(id);
    await dataSource.delete(id);
  }

  Future<IdNameList<T>> getAll() async {
    await _validateGetAllPrivileges();

    List<T> output = await dataSource.getAll();
    for (T t in output) _performAdjustments(t);
    return output;
  }

  Future<IdNameList<IdNamePair>> getAllIdsAndNames() async {
    await _validateGetAllIdsAndNamesPrivileges();
    return await dataSource.getAllIdsAndNames();
  }

  Future<T> getById(String id, {bool bypassAuth: false}) async {
    id = _normalizeId(id);
    if (!bypassAuth) await _validateGetByIdPrivileges();

    Option<T> output = await dataSource.getById(id);

    if (output.isEmpty) throw new NotFoundException("ID '${id}' not found");

    _performAdjustments(output.get());

    return output.get();
  }

  Future<IdNameList<T>> search(String query) async {
    await _validateSearchPrivileges();
    return await dataSource.search(query);
  }

  Future<String> update(String id, T t) async {
    id = _normalizeId(id);
    await _validateUpdatePrivileges(id);
    await validate(t, id != t.getId);
    return await dataSource.write(t, id);
  }

  _performAdjustments(T t) {}



  @override
  Future<Map<String, String>> _validateFields(T t, bool creating) async {
    Map<String, String> field_errors = new Map<String, String>();

    t.getId = _normalizeId(t.getId);
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

  Future _validateFieldsInternal(Map field_errors, T t, bool creating) async =>
      {};

  Future _validateGetAllIdsAndNamesPrivileges() async {
    await _validateGetPrivileges();
  }

  Future _validateGetAllPrivileges() async {
    await _validateGetPrivileges();
  }

  Future _validateGetByIdPrivileges() async {
    await _validateGetPrivileges();
  }


  Future _validateSearchPrivileges() async {
    await _validateGetPrivileges();
  }


}
