class TrophyModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  Data? data;

  TrophyModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  TrophyModel.fromJson(Map<String, dynamic> json) {
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
  List<TrophyModelData>? data;
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
      data = <TrophyModelData>[];
      json['data'].forEach((v) {
        data!.add(new TrophyModelData.fromJson(v));
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

class TrophyModelData {
  String? userTrophyId;
  String? userId;
  String? firstName;
  String? lastName;
  String? userImage;
  String? categoryId;
  String? categoryName;
  String? categoryIcon;
  String? challengeId;
  String? title;
  String? description;
  String? challengeValue;
  String? challengeIcon;
  String? trophyIcon;

  TrophyModelData(
      {this.userTrophyId,
        this.userId,
        this.firstName,
        this.lastName,
        this.userImage,
        this.categoryId,
        this.categoryName,
        this.categoryIcon,
        this.challengeId,
        this.title,
        this.description,
        this.challengeValue,
        this.challengeIcon,
        this.trophyIcon});

  TrophyModelData.fromJson(Map<String, dynamic> json) {
    userTrophyId = json['user_trophy_id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userImage = json['user_image'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
    challengeId = json['challenge_id'];
    title = json['title'];
    description = json['description'];
    challengeValue = json['challenge_value'];
    challengeIcon = json['challenge_icon'];
    trophyIcon = json['trophy_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_trophy_id'] = this.userTrophyId;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_image'] = this.userImage;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_icon'] = this.categoryIcon;
    data['challenge_id'] = this.challengeId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['challenge_value'] = this.challengeValue;
    data['challenge_icon'] = this.challengeIcon;
    data['trophy_icon'] = this.trophyIcon;
    return data;
  }
}
