part of api;

abstract class AResource {
  Logger get _logger;

  String _generateRedirect(String newId) {
    return "";
  }

  Future<dynamic> _catchExceptionsAwait(Future toAwait()) async {
    return _catchExceptions(toAwait());
  }

  Future<dynamic> _catchExceptions(Future toAwait) async {
    RpcError output;
    dynamic exception, stackTrace;

    try {
      return await toAwait;
    } on NotAuthorizedException catch(e,st) {
      exception = e;
      stackTrace = st;
      output = new RpcError(HttpStatus.UNAUTHORIZED, "Not Authorized", e.message);
    } on DataMovedException catch(e, st) {
      exception = e;
      stackTrace = st;
      String redirect = _generateRedirect(e.newId);
      if (isNullOrWhitespace(redirect))
        output = new ApplicationError(
            "Redirect information found, but could not generate new path");
      else {
        _sendRedirectHeader(redirect);
      }
    } on InvalidInputException catch(e, st) {
      exception = e;
      stackTrace = st;
      output = new BadRequestError(e.toString());
    } on DataValidationException catch(e, st) {
      exception = e;
      stackTrace = st;
      output = new BadRequestError(e.message);
      for (String field in e.fieldErrors.keys) {
        output.errors.add(new RpcErrorDetail(
            location: field,
            locationType: "field",
            message: e.fieldErrors[field]));
      }
    } on AlreadyExistsException catch(e, st) {
      exception = e;
      stackTrace = st;
      output = new RpcError(HttpStatus.CONFLICT, "Conflict", e.toString());
    } on NotFoundException catch(e, st) {
      exception = e;
      stackTrace = st;
      output = new NotFoundError(e.toString());
    } on RpcError catch(e, st) {
      _logger.severe(e, st);
      throw e;
    } on SetupDisabledException catch(e,st) {
      exception = e;
      stackTrace = st;
      output = new RpcError(HttpStatus.FORBIDDEN,"Forbidden", "Setup is disabled");
    } on SetupRequiredException catch(e,st) {
      exception = e;
      stackTrace = st;
      output = new RpcError(HTTP_STATUS_SERVER_NEEDS_SETUP,"Setup Required", "Setup is required");
    } catch(e,st) {
      exception = e;
      stackTrace = st;
      output = new ApplicationError(e.toString());
    }
    _logger.severe(exception, stackTrace);
    output.errors.add(new RpcErrorDetail(
        location: Trace.format(stackTrace, terse: true), locationType: "stackTrace"));
    throw output;
  }

  void _sendRedirectHeader(String target) {
    context.responseStatusCode = HttpStatus.MOVED_PERMANENTLY;
    context.responseHeaders[HttpHeaders.LOCATION] = target;
    throw new RpcError(HttpStatus.MOVED_PERMANENTLY," Moved Permanently",target);
  }

  Future checkIfSetupRequired() async {
    if(await model.setup.isSetupRequired())
      throw new SetupRequiredException();
  }
}
