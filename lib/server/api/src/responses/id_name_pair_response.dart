part of api;

class IdNamePairResponse {
  @ApiProperty(required: true)
  String id = "";

  @ApiProperty(required: true)
  String name = "";

  IdNamePairResponse();

  IdNamePairResponse.copy(dynamic o) {
    this.id = o.id;
    this.name = o.name;
  }

  IdNamePairResponse.from(this.id, this.name);

  static List<IdNamePairResponse> convertList(Iterable i) {
    List<IdNamePairResponse> output = new List<IdNamePairResponse>();
    for (dynamic o in i) {
      output.add(new IdNamePairResponse.copy(o));
    }
    return output;
  }
}
