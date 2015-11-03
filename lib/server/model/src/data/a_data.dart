part of model;

abstract class AData {

  void setData(dynamic data);

  Map<String, dynamic> toMap() {
    Map<String, dynamic> output = new Map<String, dynamic>();
    setData(output);
    return output;
  }
}