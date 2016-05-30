part of api;

class PasswordChangeRequest {
  @ApiProperty(required: true)
  String currentPassword;

  @ApiProperty(required: true)
  String newPassword;

  PasswordChangeRequest();

}
