class ChallengeDetailModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  Data? data;

  ChallengeDetailModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  ChallengeDetailModel.fromJson(Map<String, dynamic> json) {
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
  String? challengeId;
  String? categoryId;
  String? title;
  String? description;
  String? challengeIcon;
  String? startDate;
  String? endDate;
  String? challengeValue;
  String? categoryName;
  String? categoryIcon;
  bool? isJoined;
  List<FollowingUsers>? followingUsers;

  Data(
      {this.challengeId,
        this.categoryId,
        this.title,
        this.description,
        this.challengeIcon,
        this.startDate,
        this.endDate,
        this.challengeValue,
        this.categoryName,
        this.categoryIcon,
        this.isJoined,
        this.followingUsers});

  Data.fromJson(Map<String, dynamic> json) {
    challengeId = json['challenge_id'];
    categoryId = json['category_id'];
    title = json['title'];
    description = json['description'];
    challengeIcon = json['challenge_icon'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    challengeValue = json['challenge_value'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
    isJoined = json['is_joined'];
    if (json['following_users'] != null) {
      followingUsers = <FollowingUsers>[];
      json['following_users'].forEach((v) {
        followingUsers!.add(new FollowingUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['challenge_id'] = this.challengeId;
    data['category_id'] = this.categoryId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['challenge_icon'] = this.challengeIcon;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    data['challenge_value'] = this.challengeValue;
    data['category_name'] = this.categoryName;
    data['category_icon'] = this.categoryIcon;
    data['is_joined'] = this.isJoined;
    if (this.followingUsers != null) {
      data['following_users'] =
          this.followingUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FollowingUsers {
  String? userId;
  String? profilePhoto;
  String? firstName;
  String? lastName;

  FollowingUsers(
      {this.userId, this.profilePhoto, this.firstName, this.lastName});

  FollowingUsers.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    profilePhoto = json['profile_photo'];
    firstName = json['first_name'];
    lastName = json['last_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['profile_photo'] = this.profilePhoto;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    return data;
  }
}
