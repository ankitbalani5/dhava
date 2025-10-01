class NotificationModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  Data? data;

  NotificationModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  NotificationModel.fromJson(Map<String, dynamic> json) {
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
  List<NotificationModelData>? data;
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
      data = <NotificationModelData>[];
      json['data'].forEach((v) {
        data!.add(new NotificationModelData.fromJson(v));
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

class NotificationModelData {
  String? notificationId;
  String? toUserId;
  String? fromUserId;
  String? message;
  bool? isRead;
  String? followRequestId;
  UserProfile? userProfile;

  NotificationModelData(
      {this.notificationId,
        this.toUserId,
        this.fromUserId,
        this.message,
        this.isRead,
        this.followRequestId,
        this.userProfile});

  NotificationModelData.fromJson(Map<String, dynamic> json) {
    notificationId = json['notification_id'];
    toUserId = json['to_user_id'];
    fromUserId = json['from_user_id'];
    message = json['message'];
    isRead = json['is_read'];
    followRequestId = json['follow_request_id'];
    userProfile = json['user_profile'] != null
        ? new UserProfile.fromJson(json['user_profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['notification_id'] = this.notificationId;
    data['to_user_id'] = this.toUserId;
    data['from_user_id'] = this.fromUserId;
    data['message'] = this.message;
    data['is_read'] = this.isRead;
    data['follow_request_id'] = this.followRequestId;
    if (this.userProfile != null) {
      data['user_profile'] = this.userProfile!.toJson();
    }
    return data;
  }
}

class UserProfile {
  String? userId;
  String? profilePhoto;
  String? firstName;
  String? lastName;

  UserProfile({this.userId, this.profilePhoto, this.firstName, this.lastName});

  UserProfile.fromJson(Map<String, dynamic> json) {
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
