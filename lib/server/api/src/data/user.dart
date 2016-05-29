part of api;

class User extends AData {
  @ApiProperty(required: true)
  String password;

  @ApiProperty(required: true)
  String type;

  User();
}
