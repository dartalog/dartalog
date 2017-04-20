import 'dart:async';

import 'responses/id_response.dart';
import 'package:dartalog/data/data.dart';
import 'package:dartalog/model/model.dart' as model;
import 'package:meta/meta.dart';
import 'package:rpc/rpc.dart';

import 'a_resource.dart';

abstract class AIdResource<T extends AUuidData> extends AResource {
  model.AUuidBasedModel<T> get idModel;

  Future<IdResponse> create(T t);
  @protected
  Future<IdResponse> createWithCatch(T t, {List<MediaMessage> mediaMessages}) =>
      catchExceptionsAwait(() async {
        String output;

        List<List<int>> files;
        if (mediaMessages != null) {
          files = convertMediaMessagesToIntLists(mediaMessages);
        }

        if (idModel is model.AFileUploadModel<T>) {
          final model.AFileUploadModel<T> fileModel =
              idModel as model.AFileUploadModel<T>;
          output = await fileModel.create(t, files: files);
        } else {
          output = await idModel.create(t);
        }
        return new IdResponse.fromId(output, this.generateRedirect(output));
      });

  Future<VoidMessage> delete(String uuid);
  @protected
  Future<VoidMessage> deleteWithCatch(String uuid) =>
      catchExceptionsAwait(() async {
        await idModel.delete(uuid);
        return new VoidMessage();
      });

  Future<T> getByUuid(String uuid);

  Future<IdResponse> update(String uuid, T t);

  @protected
  Future<T> getByUuidWithCatch(String uuid) =>
      catchExceptionsAwait(() async => idModel.getByUuid(uuid));

  @protected
  Future<IdResponse> updateWithCatch(String uuid, T t,
          {List<MediaMessage> mediaMessages}) =>
      catchExceptionsAwait(() async {
        List<List<int>> files;
        if (mediaMessages != null) {
          files = convertMediaMessagesToIntLists(mediaMessages);
        }

        String output;
        if (idModel is model.AFileUploadModel<T>) {
          final model.AFileUploadModel<T> fileModel =
              idModel as model.AFileUploadModel<T>;
          output = await fileModel.update(uuid, t, files: files);
        } else {
          output = await idModel.update(uuid, t);
        }

        return new IdResponse.fromId(output, this.generateRedirect(output));
      });

  @protected
  List<List<int>> convertMediaMessagesToIntLists(List<MediaMessage> input) {
    final List<List<int>> output = <List<int>>[];
    for (MediaMessage mm in input) {
      output.add(mm.bytes);
    }
    return output;
  }
}
