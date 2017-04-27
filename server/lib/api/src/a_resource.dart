import 'dart:async';
import 'dart:io';

import 'package:dartalog_shared/global.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart';
import 'package:dartalog/server.dart';
import 'package:dartalog_shared/tools.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:rpc/rpc.dart';
import 'package:stack_trace/stack_trace.dart';
import '../api.dart';

abstract class AResource {
  @protected
  Logger get childLogger;

  String get resourcePath => "";

  @protected
  Future<dynamic> catchExceptionsAwait(Future<dynamic> toAwait()) async {
    return _catchExceptions(toAwait());
  }

  @protected
  @virtual
  String generateRedirect(String newId) {
    return "";
  }

  Future<dynamic> _catchExceptions(Future<dynamic> toAwait) async {
    RpcError output;
    dynamic exception, stackTrace;

    try {
      if (resourcePath != setupApiPath &&
          await isSetupAvailable()) {
        throw new SetupRequiredException();
      }

      return await toAwait;
    } on UnauthorizedException catch (e, st) {
      exception = e;
      stackTrace = st;
      output =
          new RpcError(HttpStatus.UNAUTHORIZED, "Not Authorized", e.message);
    } on ForbiddenException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new RpcError(HttpStatus.FORBIDDEN, "Forbidden", e.message);
    } on DataMovedException catch (e, st) {
      exception = e;
      stackTrace = st;
      final String redirect = generateRedirect(e.newId);
      if (StringTools.isNullOrWhitespace(redirect))
        output = new ApplicationError(
            "Redirect information found, but could not generate new path");
      else {
        _sendRedirectHeader(redirect);
      }
    } on InvalidInputException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new BadRequestError(e.toString());
    } on DataValidationException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new BadRequestError(e.message);
      for (String field in e.fieldErrors.keys) {
        output.errors.add(new RpcErrorDetail(
            location: field,
            locationType: "field",
            message: e.fieldErrors[field]));
      }
    } on ItemActionException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new BadRequestError(e.message);
      for (String id in e.itemActionErrors.keys) {
        output.errors.add(new RpcErrorDetail(
            location: id,
            locationType: "itemCopy",
            message: e.itemActionErrors[id]));
      }
    } on TransferException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new BadRequestError(e.message);
      for (String id in e.transferErrors.keys) {
        output.errors.add(new RpcErrorDetail(
            location: id,
            locationType: "itemCopy",
            message: e.transferErrors[id]));
      }
    } on AlreadyExistsException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new RpcError(HttpStatus.CONFLICT, "Conflict", e.toString());
    } on NotFoundException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new NotFoundError(e.toString());
    } on RpcError catch (e, st) {
      childLogger.severe(e, st);
      throw e;
    } on SetupDisabledException catch (e, st) {
      exception = e;
      stackTrace = st;
      output =
          new RpcError(HttpStatus.FORBIDDEN, "Forbidden", "Setup is disabled");
    } on SetupRequiredException catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new RpcError(
          httpStatusServerNeedsSetup, "Setup Required", "Setup is required");
    } catch (e, st) {
      exception = e;
      stackTrace = st;
      output = new ApplicationError(e.toString());
    }
    childLogger.severe(exception, stackTrace);
    output.errors.add(new RpcErrorDetail(
        location: Trace.format(stackTrace, terse: true),
        locationType: "stackTrace"));

    output.errors.add(new RpcErrorDetail(
        location: exception.runtimeType.toString(),
        locationType: "exceptionType"));

    throw output;
  }

  void _sendRedirectHeader(String target) {
    context.responseStatusCode = HttpStatus.MOVED_PERMANENTLY;
    context.responseHeaders[HttpHeaders.LOCATION] = target;
    throw new RpcError(
        HttpStatus.MOVED_PERMANENTLY, " Moved Permanently", target);
  }
}
