class NewsDetailModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  Data? data;

  NewsDetailModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  NewsDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? newsId;
  String? title;
  String? image;
  String? description;
  String? newsDatetime;
  String? createdDate;

  Data(
      {this.newsId,
        this.title,
        this.image,
        this.description,
        this.newsDatetime,
        this.createdDate});

  Data.fromJson(Map<String, dynamic> json) {
    newsId = json['news_id'];
    title = json['title'];
    image = json['image'];
    description = json['description'];
    newsDatetime = json['news_datetime'];
    createdDate = json['created_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['news_id'] = this.newsId;
    data['title'] = this.title;
    data['image'] = this.image;
    data['description'] = this.description;
    data['news_datetime'] = this.newsDatetime;
    data['created_date'] = this.createdDate;
    return data;
  }
}
