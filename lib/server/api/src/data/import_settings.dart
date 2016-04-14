part of api;

class ImportSettings extends AData {
  String provider;

  @ApiProperty(required: true)
  Map<String, String> fieldValues = new Map<String, String>();

  ImportSettings();

  void validate() {
  }
}