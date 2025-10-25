class NewsModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  Data? data;

  NewsModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  NewsModel.fromJson(Map<String, dynamic> json) {
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
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<NewsData>? data;
  int? lastPage;
  int? pageList;

  Data(
      {this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.data,
        this.lastPage,
        this.pageList});

  Data.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <NewsData>[];
      json['data'].forEach((v) {
        data!.add(new NewsData.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    pageList = json['pageList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    data['per_page'] = this.perPage;
    data['total'] = this.total;
    data['total_pages'] = this.totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['lastPage'] = this.lastPage;
    data['pageList'] = this.pageList;
    return data;
  }
}

class NewsData {
  String? newsId;
  String? title;
  String? image;
  String? description;
  String? newsDatetime;
  String? createdDate;

  NewsData(
      {this.newsId,
        this.title,
        this.image,
        this.description,
        this.newsDatetime,
        this.createdDate});

  NewsData.fromJson(Map<String, dynamic> json) {
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
