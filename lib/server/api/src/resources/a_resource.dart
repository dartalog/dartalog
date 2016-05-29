part of api;

abstract class AResource {
  Logger get _logger;

  String _generateRedirect(String newId) {
    return "";
  }

  void _HandleException(e, st) {
    _logger.severe(e, st);
    RpcError output;
    if (e is model.DataMovedException) {
      model.DataMovedException dme = e as model.DataMovedException;
      String redirect = _generateRedirect(dme.newId);
      if (isNullOrWhitespace(redirect))
        output = new ApplicationError(
            "Redirect information found, but could not generate new path");
      else {
        _sendRedirect(redirect);
        return;
      }
    } else if (e is model.InvalidInputException) {
      output = new BadRequestError(e.toString());
    } else if (e is DataValidationException) {
      DataValidationException dve = e as DataValidationException;
      output = new BadRequestError(e.message);
      for (String field in e.fieldErrors.keys) {
        output.errors.add(new RpcErrorDetail(
            location: field,
            locationType: "field",
            message: dve.fieldErrors[field]));
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

  void _sendRedirect(String target) {
    context.responseStatusCode = HttpStatus.MOVED_PERMANENTLY;
    context.responseHeaders[HttpHeaders.LOCATION] = target;
  }
}
