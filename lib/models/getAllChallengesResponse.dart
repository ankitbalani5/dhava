class GetAllChallengesResponse {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  List<Data>? data;

  GetAllChallengesResponse(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  GetAllChallengesResponse.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['status_code'] = this.statusCode;
    data['message'] = this.message;
    data['error_message'] = this.errorMessage;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
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

  Data(
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

  Data.fromJson(Map<String, dynamic> json) {
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
