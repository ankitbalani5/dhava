class ActivityLikeModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  Data? data;

  ActivityLikeModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  ActivityLikeModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['error_message'] = this.errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? isLiked;

  Data({this.isLiked});

  Data.fromJson(Map<String, dynamic> json) {
    isLiked = json['is_liked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['is_liked'] = this.isLiked;
    return data;
  }
}
