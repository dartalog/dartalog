class IdResponse {
  String uuid;
  String location;

  IdResponse();

  IdResponse.fromId(this.uuid, [this.location]);
}
