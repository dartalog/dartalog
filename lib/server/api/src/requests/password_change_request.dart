part of api;

class PasswordChangeRequest {
  @ApiProperty(required: true)
  String currentPassword;

  @ApiProperty(required: true)
  String newPassword;

  PasswordChangeRequest();

  void validate(User user) {
    Map<String, String> field_errors = new Map<String, String>();

    if (isNullOrWhitespace(currentPassword)) {
      field_errors["currentPassword"] = "Required";
    } else if(!user.verifyPassword(this.currentPassword)) {
      field_errors["currentPassword"] = "Incorrect";
    }

    if (isNullOrWhitespace(newPassword)) {
      field_errors["newPassword"] = "Required";
    } else if(newPassword.length < 8) {
      field_errors["newPassword"] = "Must be at least 8 digits long";
    }


    if (field_errors.length > 0) {
      throw new DataValidationException.WithFieldErrors(
          "Invalid data_sources", field_errors);
    }
  }
}
