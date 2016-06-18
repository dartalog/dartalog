part of model;

abstract class AIdNameBasedModel<T extends AIdData> extends AModel {
  AIdNameBasedDataSource<T> get dataSource;

  Future<String> create(T t) async {
    if (!_userAuthenticated) {
      throw new NotAuthorizedException();
    }
    await _validateDefaultPrivilegeRequirement();

    await validate(t, true);
    return await dataSource.write(t);
  }

  Future delete(String id) async {
    if (!_userAuthenticated) {
      throw new NotAuthorizedException();
    }
    await _validateDefaultPrivilegeRequirement();

    await dataSource.delete(id);
  }

  Future<IdNameList<T>> getAll() async {
    await _validateDefaultPrivilegeRequirement();

    List<T> output = await dataSource.getAll();
    for (T t in output) _performAdjustments(t);
    return output;
  }

  Future<IdNameList<IdNamePair>> getAllIdsAndNames() async {
    await _validateDefaultPrivilegeRequirement();
    return await dataSource.getAllIdsAndNames();
  }

  Future<T> getById(String id, {bool bypassAuth: false}) async {
    if (!bypassAuth) await _validateDefaultPrivilegeRequirement();

    Option<T> output = await dataSource.getById(id);

    if (output.isEmpty) throw new NotFoundException("ID '${id}' not found");

    _performAdjustments(output.get());

    return output.get();
  }

  Future<PaginatedIdNameData<T>> getPaginated({int offset: 0}) async {
    await _validateDefaultPrivilegeRequirement();

    PaginatedIdNameData<T> output =
        await dataSource.getPaginated(offset: offset);
    for (T t in output.data) _performAdjustments(t);
    return output;
  }

  Future<PaginatedIdNameData<IdNamePair>> getPaginatedIdsAndNames(
      {int offset: 0}) async {
    await _validateDefaultPrivilegeRequirement();
    return await dataSource.getPaginatedIdsAndNames(offset: offset);
  }

  Future<IdNameList<T>> search(String query) async {
    await _validateDefaultPrivilegeRequirement();
    return await dataSource.search(query);
  }

  Future<PaginatedIdNameData<T>> searchPaginated(String query,
      {int offset: 0}) async {
    await _validateDefaultPrivilegeRequirement();
    return await dataSource.searchPaginated(query, offset: offset);
  }

  Future<String> update(String id, T t) async {
    if (!_userAuthenticated) {
      throw new NotAuthorizedException();
    }
    await _validateDefaultPrivilegeRequirement();

    await validate(t, id != t.getId);
    return await dataSource.write(t, id);
  }

  _performAdjustments(T t) {}

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

  Future _validateFieldsInternal(Map field_errors, T t, bool creating) async =>
      {};
}
