import 'package:dartalog/server/data_sources/data_sources.dart' as data_sources;
import 'package:dartalog/tools.dart';
import 'package:dartalog/server/data/data.dart';
import 'package:test/test.dart';

void main() {
  test("Generate UUID", () {
    generateUuid();
  });

  final String collectionUuid = generateUuid();

  test("Create collection", () async {
    final Collection newCol = new Collection();
    newCol.name = "TEST";
    newCol.readableId = "TEST";
    await data_sources.itemCollections.create(collectionUuid, newCol);
  });
}
