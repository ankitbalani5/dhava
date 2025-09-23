class ProfileModel {
  bool? status;
  int? statusCode;

  @override
  String toString() {
    return 'ProfileModel{status: $status, statusCode: $statusCode, message: $message, errorMessage: $errorMessage, data: $data}';
  }

  String? message;
  Null? errorMessage;
  Data? data;

  ProfileModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  ProfileModel.fromJson(Map<String, dynamic> json) {
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
  String? userDetailId;
  String? userId;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  String? city;
  String? state;
  String? address;
  String? country;
  Null? mobile;
  String? email;
  bool? isProfileCompleted;
  String? bio;
  String? dob;
  double? height;
  double? weight;
  String? gender;
  Null? heightUnitId;
  Null? heightUnitName;
  Null? heightUnitType;
  Null? weightUnitId;
  Null? weightUnitName;
  Null? weightUnitType;
  int? totalFollowers;
  int? totalFollowing;
  String? fitnessLevel;
  String? planToUse;
  String? latitude;
  String? longitude;
  List<Categories>? categories;

  Data(
      {this.userDetailId,
        this.userId,
        this.firstName,
        this.lastName,
        this.profilePhoto,
        this.city,
        this.state,
        this.address,
        this.country,
        this.mobile,
        this.email,
        this.isProfileCompleted,
        this.bio,
        this.dob,
        this.height,
        this.weight,
        this.gender,
        this.heightUnitId,
        this.heightUnitName,
        this.heightUnitType,
        this.weightUnitId,
        this.weightUnitName,
        this.weightUnitType,
        this.totalFollowers,
        this.totalFollowing,
        this.fitnessLevel,
        this.planToUse,
        this.latitude,
        this.longitude,
        this.categories});

  Data.fromJson(Map<String, dynamic> json) {
    userDetailId = json['user_detail_id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    city = json['city'];
    state = json['state'];
    address = json['address'];
    country = json['country'];
    mobile = json['mobile'];
    email = json['email'];
    isProfileCompleted = json['is_profile_completed'];
    bio = json['bio'];
    dob = json['dob'];
    height = json['height'];
    weight = json['weight'];
    gender = json['gender'];
    heightUnitId = json['height_unit_id'];
    heightUnitName = json['height_unit_name'];
    heightUnitType = json['height_unit_type'];
    weightUnitId = json['weight_unit_id'];
    weightUnitName = json['weight_unit_name'];
    weightUnitType = json['weight_unit_type'];
    totalFollowers = json['total_followers'];
    totalFollowing = json['total_following'];
    fitnessLevel = json['fitness_level'];
    planToUse = json['plan_to_use'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_detail_id'] = this.userDetailId;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_photo'] = this.profilePhoto;
    data['city'] = this.city;
    data['state'] = this.state;
    data['address'] = this.address;
    data['country'] = this.country;
    data['mobile'] = this.mobile;
    data['email'] = this.email;
    data['is_profile_completed'] = this.isProfileCompleted;
    data['bio'] = this.bio;
    data['dob'] = this.dob;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['gender'] = this.gender;
    data['height_unit_id'] = this.heightUnitId;
    data['height_unit_name'] = this.heightUnitName;
    data['height_unit_type'] = this.heightUnitType;
    data['weight_unit_id'] = this.weightUnitId;
    data['weight_unit_name'] = this.weightUnitName;
    data['weight_unit_type'] = this.weightUnitType;
    data['total_followers'] = this.totalFollowers;
    data['total_following'] = this.totalFollowing;
    data['fitness_level'] = this.fitnessLevel;
    data['plan_to_use'] = this.planToUse;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Categories {
  String? categoryId;
  String? categoryName;
  String? categoryIcon;

  Categories({this.categoryId, this.categoryName, this.categoryIcon});

  Categories.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_icon'] = this.categoryIcon;
    return data;
  }
}
