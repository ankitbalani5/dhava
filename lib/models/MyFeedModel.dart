class MyFeedModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  Data? data;

  MyFeedModel({
    this.status,
    this.statusCode,
    this.message,
    this.errorMessage,
    this.data,
  });

  MyFeedModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['status'] = status;
    data['status_code'] = statusCode;
    data['message'] = message;
    data['error_message'] = errorMessage;
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
  List<MyFeedModelData>? data;
  int? lastPage;
  int? pageList;

  Data({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
    this.lastPage,
    this.pageList,
  });

  Data.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    perPage = json['per_page'];
    total = json['total'];
    totalPages = json['total_pages'];
    if (json['data'] != null) {
      data = <MyFeedModelData>[];
      json['data'].forEach((v) {
        data!.add(MyFeedModelData.fromJson(v));
      });
    }
    lastPage = json['lastPage'];
    pageList = json['pageList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['page'] = page;
    data['per_page'] = perPage;
    data['total'] = total;
    data['total_pages'] = totalPages;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['lastPage'] = lastPage;
    data['pageList'] = pageList;
    return data;
  }
}

class MyFeedModelData {
  String? firstName;
  String? lastName;
  String? profilePic;
  String? userId;
  String? categoryId;
  String? activityId;
  String? categoryName;
  String? title;
  String? description;
  String? photo;
  String? distance;
  String? pace;
  int? movingTime;
  String? location;
  String? elavationGain;
  String? maxElavation;
  int? steps;
  String? fastestSplit;
  List<PathPoint>? path; // Null की जगह custom PathPoint model
  String? runType;
  String? typeOfRun;
  String? feeling;
  String? privateNote;
  String? gear;
  String? visibility;
  String? hiddenDetails;
  bool? muteActivity;
  String? type;
  String? avgElapsedPace;
  String? elapsedTime;
  String? maxSpeed;
  int? totalLike;
  bool? isLiked;
  String? createdDate;
  String? categoryIcon;
  List<LikedUsers>? likedUsers;

  MyFeedModelData({
    this.firstName,
    this.lastName,
    this.profilePic,
    this.userId,
    this.categoryId,
    this.activityId,
    this.categoryName,
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
    this.categoryIcon,
    this.likedUsers,
  });

  MyFeedModelData.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    userId = json['user_id'];
    categoryId = json['category_id'];
    activityId = json['activity_id'];
    categoryName = json['category_name'];
    title = json['title'];
    description = json['description'];
    photo = json['photo'];
    distance = (json['distance'] as num?)?.toString();
    pace = json['pace'].toString();
    movingTime = json['moving_time'];
    location = json['location'];
    elavationGain = json['elavation_gain'].toString();
    maxElavation = json['max_elavation'].toString();
    steps = json['steps'];
    fastestSplit = json['fastest_split'].toString();
    if (json['path'] != null) {
      path = <PathPoint>[];
      json['path'].forEach((v) {
        path!.add(PathPoint.fromJson(v));
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
    avgElapsedPace = json['avg_elapsed_pace'].toString();
    elapsedTime = json['elapsed_time'].toString();
    maxSpeed = json['max_speed'].toString();
    totalLike = json['total_like'];
    isLiked = json['is_liked'];
    createdDate = json['created_date'];
    categoryIcon = json['category_icon'];
    if (json['liked_users'] != null) {
      likedUsers = <LikedUsers>[];
      json['liked_users'].forEach((v) {
        likedUsers!.add(LikedUsers.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['profile_pic'] = profilePic;
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    data['activity_id'] = activityId;
    data['category_name'] = categoryName;
    data['title'] = title;
    data['description'] = description;
    data['photo'] = photo;
    data['distance'] = distance;
    data['pace'] = pace;
    data['moving_time'] = movingTime;
    data['location'] = location;
    data['elavation_gain'] = elavationGain;
    data['max_elavation'] = maxElavation;
    data['steps'] = steps;
    data['fastest_split'] = fastestSplit;
    if (path != null) {
      data['path'] = path!.map((v) => v.toJson()).toList();
    }
    data['run_type'] = runType;
    data['type_of_run'] = typeOfRun;
    data['feeling'] = feeling;
    data['private_note'] = privateNote;
    data['gear'] = gear;
    data['visibility'] = visibility;
    data['hidden_details'] = hiddenDetails;
    data['mute_activity'] = muteActivity;
    data['type'] = type;
    data['avg_elapsed_pace'] = avgElapsedPace;
    data['elapsed_time'] = elapsedTime;
    data['max_speed'] = maxSpeed;
    data['total_like'] = totalLike;
    data['is_liked'] = isLiked;
    data['created_date'] = createdDate;
    data['category_icon'] = categoryIcon;
    if (likedUsers != null) {
      data['liked_users'] = likedUsers!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class PathPoint {
  double? lat;
  double? lng;

  PathPoint({this.lat, this.lng});

  PathPoint.fromJson(Map<String, dynamic> json) {
    lat = (json['lat'] as num?)?.toDouble();
    lng = (json['lng'] as num?)?.toDouble();
  }

  Map<String, dynamic> toJson() {
    return {
      'lat': lat,
      'lng': lng,
    };
  }
}

class LikedUsers {
  String? firstName;
  String? lastName;
  String? profilePic;
  String? userId;
  bool? isActive;

  LikedUsers({
    this.firstName,
    this.lastName,
    this.profilePic,
    this.userId,
    this.isActive,
  });

  LikedUsers.fromJson(Map<String, dynamic> json) {
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePic = json['profile_pic'];
    userId = json['user_id'];
    isActive = json['is_active'];
  }

  Map<String, dynamic> toJson() {
    return {
      'first_name': firstName,
      'last_name': lastName,
      'profile_pic': profilePic,
      'user_id': userId,
      'is_active': isActive,
    };
  }
}
