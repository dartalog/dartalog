part of api;

abstract class AData {
  String id;

  Future validate(bool verifyId);
  //void setData(dynamic data);

//  Map<String, dynamic> toMap() {
//    Map<String, dynamic> output = new Map<String, dynamic>();
//    setData(output);
//    return output;
//  }
}