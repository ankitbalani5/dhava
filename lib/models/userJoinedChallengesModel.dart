class UserJoinedChallengesModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  UserJoinedData? data;

  UserJoinedChallengesModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  UserJoinedChallengesModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    data = json['data'] != null ? new UserJoinedData.fromJson(json['data']) : null;
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

class UserJoinedData {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<Data>? data;
  int? lastPage;
  int? pageList;

  UserJoinedData(
      {this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.data,
        this.lastPage,
        this.pageList});

  UserJoinedData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
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

class Data {
  String? challengeId;
  String? categoryId;
  String? categoryName;
  String? categoryIcon;
  String? title;
  String? description;
  String? challengeIcon;
  String? startDate;
  String? endDate;
  String? challengeValue;
  String? userId;
  String? firstName;
  String? lastName;
  String? userImage;

  Data(
      {this.challengeId,
        this.categoryId,
        this.categoryName,
        this.categoryIcon,
        this.title,
        this.description,
        this.challengeIcon,
        this.startDate,
        this.endDate,
        this.challengeValue,
        this.userId,
        this.firstName,
        this.lastName,
        this.userImage});

  Data.fromJson(Map<String, dynamic> json) {
    challengeId = json['challenge_id'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
    title = json['title'];
    description = json['description'];
    challengeIcon = json['challenge_icon'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    challengeValue = json['challenge_value'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userImage = json['user_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_icon'] = this.categoryIcon;
    data['title'] = this.title;
    data['description'] = this.description;
    data['challenge_icon'] = this.challengeIcon;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['challenge_value'] = this.challengeValue;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_image'] = this.userImage;
    return data;
  }
}
