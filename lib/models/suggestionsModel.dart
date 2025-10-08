class SuggestionsModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  SuggestionsData? data;

  SuggestionsModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  SuggestionsModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    data = json['data'] != null ? new SuggestionsData.fromJson(json['data']) : null;
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

class SuggestionsData {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<UserData>? data;
  int? lastPage;
  int? pageList;

  SuggestionsData(
      {this.page,
        this.perPage,
        this.total,
        this.totalPages,
        this.data,
        this.lastPage,
        this.pageList});

  SuggestionsData.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <UserData>[];
      json['data'].forEach((v) {
        data!.add(new UserData.fromJson(v));
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

class UserData {
  String? userId;
  String? firstName;
  String? lastName;
  String? latitude;
  String? longitude;
  String? location;
  String? profilePhoto;
  bool? isFollowed;
  bool? isFollowRequested;

  UserData(
      {this.userId,
        this.firstName,
        this.lastName,
        this.latitude,
        this.longitude,
        this.location,
        this.profilePhoto,
        this.isFollowed,
        this.isFollowRequested});

  UserData.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    location = json['location'];
    profilePhoto = json['profile_photo'];
    isFollowed = json['is_followed'];
    isFollowRequested = json['is_follow_requested'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    data['location'] = this.location;
    data['profile_photo'] = this.profilePhoto;
    data['is_followed'] = this.isFollowed;
    data['is_follow_requested'] = this.isFollowRequested;
    return data;
  }
}
