class CommonResponseModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  dynamic? data;

  CommonResponseModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  CommonResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['statusCode'];
    message = json['message'];
    errorMessage = json['error_message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['statusCode'] = this.statusCode;
    data['message'] = this.message;
    data['error_message'] = this.errorMessage;
    data['data'] = this.data;
    return data;
  }
}
