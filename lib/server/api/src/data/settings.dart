part of api;

class ImportSettings extends AData {
  String name;

  @ApiProperty(required: true)
  Map<String, String> fieldValues = new Map<String, String>();

  ImportSettings();

  Future validate() async {}
}
