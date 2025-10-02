class CreatePasswordModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  Null? data;

  CreatePasswordModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  CreatePasswordModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    data = json['data'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['error_message'] = this.errorMessage;
    data['data'] = this.data;
    return data;
  }
}
