
class FeedModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  Data? data;

  FeedModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  FeedModel.fromJson(Map<String, dynamic> json) {
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
  List<FeedModelData>? data;
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
      data = <FeedModelData>[];
      json['data'].forEach((v) {
        data!.add(new FeedModelData.fromJson(v));
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

class FeedModelData {
  String? firstName;
  String? userId;
  String? lastName;
  String? profilePic;
  String? categoryId;
  String? activityId;
  String? categoryName;
  String? categoryIcon;
  String? title;
  String? description;
  String? photo;
  double? distance;
  double? pace;
  int? movingTime;
  String? location;
  String? elavationGain;
  String? maxElavation;
  int? steps;
  double? fastestSplit;
  List<Path>? path;
  String? runType;
  String? typeOfRun;
  String? feeling;
  String? privateNote;
  String? gear;
  String? visibility;
  String? hiddenDetails;
  bool? muteActivity;
  String? type;
  double? avgElapsedPace;
  double? elapsedTime;
  double? maxSpeed;
  int? totalLike;
  bool? isLiked;
  String? createdDate;
  List<LikedUsers>? likedUsers;

  FeedModelData(
      {this.firstName,
        this.userId,
        this.lastName,
        this.profilePic,
        this.categoryId,
        this.activityId,
        this.categoryName,
        this.categoryIcon,
        this.title,
        this.description,
        this.photo,
        this.distance,
        this.pace,
        this.movingTime,
        this.location,
        this.elavationGain,
        this.maxElavation,
        this.steps,
        this.fastestSplit,
        this.path,
        this.runType,
        this.typeOfRun,
        this.feeling,
        this.privateNote,
        this.gear,
        this.visibility,
        this.hiddenDetails,
        this.muteActivity,
        this.type,
        this.avgElapsedPace,
        this.elapsedTime,
        this.maxSpeed,
        this.totalLike,
        this.isLiked,
        this.createdDate,
        this.likedUsers});

  FeedModelData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    userId = json['user_id'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    categoryId = json['category_id'];
    activityId = json['activity_id'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
    title = json['title'];
    description = json['description'];
    photo = json['photo'];
    distance = json['distance'];
    pace = json['pace'];
    movingTime = json['moving_time'];
    location = json['location'];
    elavationGain = json['elavation_gain'].toString();
    maxElavation = json['max_elavation'].toString();
    steps = json['steps'];
    fastestSplit = json['fastest_split'];
    if (json['path'] != null) {
      path = <Path>[];
      json['path'].forEach((v) {
        path!.add(new Path.fromJson(v));
      });
    }
    runType = json['run_type'];
    typeOfRun = json['type_of_run'];
    feeling = json['feeling'];
    privateNote = json['private_note'];
    gear = json['gear'];
    visibility = json['visibility'];
    hiddenDetails = json['hidden_details'];
    muteActivity = json['mute_activity'];
    type = json['type'];
    avgElapsedPace = json['avg_elapsed_pace'];
    elapsedTime = json['elapsed_time'];
    maxSpeed = json['max_speed'];
    totalLike = json['total_like'];
    isLiked = json['is_liked'];
    createdDate = json['created_date'];
    if (json['liked_users'] != null) {
      likedUsers = <LikedUsers>[];
      json['liked_users'].forEach((v) {
        likedUsers!.add(new LikedUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['user_id'] = this.userId;
    data['last_name'] = this.lastName;
    data['profile_pic'] = this.profilePic;
    data['category_id'] = this.categoryId;
    data['activity_id'] = this.activityId;
    data['category_name'] = this.categoryName;
    data['category_icon'] = this.categoryIcon;
    data['title'] = this.title;
    data['description'] = this.description;
    data['photo'] = this.photo;
    data['distance'] = this.distance;
    data['pace'] = this.pace;
    data['moving_time'] = this.movingTime;
    data['location'] = this.location;
    data['elavation_gain'] = this.elavationGain;
    data['max_elavation'] = this.maxElavation;
    data['steps'] = this.steps;
    data['fastest_split'] = this.fastestSplit;
    if (this.path != null) {
      data['path'] = this.path!.map((v) => v.toJson()).toList();
    }
    data['run_type'] = this.runType;
    data['type_of_run'] = this.typeOfRun;
    data['feeling'] = this.feeling;
    data['private_note'] = this.privateNote;
    data['gear'] = this.gear;
    data['visibility'] = this.visibility;
    data['hidden_details'] = this.hiddenDetails;
    data['mute_activity'] = this.muteActivity;
    data['type'] = this.type;
    data['avg_elapsed_pace'] = this.avgElapsedPace;
    data['elapsed_time'] = this.elapsedTime;
    data['max_speed'] = this.maxSpeed;
    data['total_like'] = this.totalLike;
    data['is_liked'] = this.isLiked;
    data['created_date'] = this.createdDate;
    if (this.likedUsers != null) {
      data['liked_users'] = this.likedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Path {
  String? latitude;
  String? longitude;

  Path({this.latitude, this.longitude});

  Path.fromJson(Map<String, dynamic> json) {
    latitude = json['latitude'].toString();
    longitude = json['longitude'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}

class LikedUsers {
  String? firstName;
  String? lastName;
  String? profilePic;
  String? userId;
  bool? isActive;

  LikedUsers(
      {this.firstName,
        this.lastName,
        this.profilePic,
        this.userId,
        this.isActive});

  LikedUsers.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    userId = json['user_id'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_pic'] = this.profilePic;
    data['user_id'] = this.userId;
    data['is_active'] = this.isActive;
    return data;
  }
}
