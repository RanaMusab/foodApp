class BaseResponse {
  BaseResponse({this.code, this.data,this.message,this.status});

  BaseResponse.fromJson(dynamic json) {
    status = json['status'];
    message = json['message'];
    code = json['code'];
    data = json['result'];
  }

  bool? status;
  String? message;
  int? code;
  dynamic data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['code'] = code;
    map['result'] = data;
    map['message'] = message;
    map['status'] = status;
    return map;
  }

  bool haveError() =>  code != 200;
}
