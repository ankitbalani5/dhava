class PostSuggestedModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  AllChallengesData? data;

  PostSuggestedModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  PostSuggestedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    data = json['data'] != null ? new AllChallengesData.fromJson(json['data']) : null;
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

class AllChallengesData {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<ChallengesData>? data;
  int? lastPage;
  int? pageList;

  AllChallengesData(
      {this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.data,
        this.lastPage,
        this.pageList});

  AllChallengesData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <ChallengesData>[];
      json['data'].forEach((v) {
        data!.add(new ChallengesData.fromJson(v));
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

class ChallengesData {
  String? challengeId;
  String? categoryId;
  String? title;
  String? description;
  String? startDate;
  String? endDate;
  String? challengeValue;
  String? categoryName;
  String? categoryIcon;
  bool? isJoined;

  ChallengesData(
      {this.challengeId,
        this.categoryId,
        this.title,
        this.description,
        this.startDate,
        this.endDate,
        this.challengeValue,
        this.categoryName,
        this.categoryIcon,
        this.isJoined});

  ChallengesData.fromJson(Map<String, dynamic> json) {
    challengeId = json['challenge_id'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    challengeValue = json['challenge_value'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
    isJoined = json['is_joined'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['challenge_value'] = this.challengeValue;
    data['category_name'] = this.categoryName;
    data['category_icon'] = this.categoryIcon;
    data['is_joined'] = this.isJoined;
    return data;
  }
}
