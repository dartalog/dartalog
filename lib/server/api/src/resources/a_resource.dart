part of api;

abstract class AResource {

  Logger _GetLogger();

  void _HandleException(e, st) {
    _GetLogger().severe(e,st);
    if(e is InvalidInputException) {
      throw new BadRequestError(e.toString())
        ..errors.add(new RpcErrorDetail(location: Trace.format(st, terse: true), locationType: "stackTrace" ));
    } else if(e is AlreadyExistsException) {
        throw new RpcError(406, "Conflict", e.toString())
          ..errors.add(new RpcErrorDetail(location: Trace.format(st, terse: true), locationType: "stackTrace" ));
    } else if(e is NotFoundException) {
      throw new NotFoundError(e.toString())
        ..errors.add(new RpcErrorDetail(location: Trace.format(st, terse: true), locationType: "stackTrace" ));
    } else {
      throw new ApplicationError(e.toString())
        ..errors.add(new RpcErrorDetail(location: Trace.format(st, terse: true), locationType: "stackTrace" ));
    }
  }
}