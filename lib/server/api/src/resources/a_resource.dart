part of api;

abstract class AResource {

  Logger _GetLogger();

  void sendRedirect(String target) {
    context.responseStatusCode = HttpStatus.MOVED_PERMANENTLY;
    context.responseHeaders[HttpHeaders.LOCATION] =  target;
  }

  void _HandleException(e, st) {
    _GetLogger().severe(e, st);
    RpcError output;
    if (e is model.InvalidInputException) {
      output = new BadRequestError(e.toString());
    } else if (e is DataValidationException) {
      DataValidationException dve = e as DataValidationException;
      output = new BadRequestError(e.message);
      for(String field in e.fieldErrors.keys){
        output.errors.add(new RpcErrorDetail(
            location: field, locationType: "field", message: dve.fieldErrors[field]));
      }
    } else if (e is model.AlreadyExistsException) {
      output = new RpcError(406, "Conflict", e.toString());
    } else if (e is model.NotFoundException) {
      output = new NotFoundError(e.toString());
    } else if (e is RpcError) {
      throw e;
    } else {
      output = new ApplicationError(e.toString());
    }
    output.errors.add(new RpcErrorDetail(
        location: Trace.format(st, terse: true), locationType: "stackTrace"));
    throw output;
  }
}