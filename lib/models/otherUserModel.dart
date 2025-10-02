class OtherUserModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  Data? data;

  OtherUserModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  OtherUserModel.fromJson(Map<String, dynamic> json) {
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
  String? userId;
  String? firstName;
  String? lastName;
  String? profilePhoto;
  Null? city;
  Null? state;
  Null? country;
  Null? address;
  Null? gender;
  String? dob;
  Null? bio;
  Null? height;
  Null? weight;
  Null? heightUnitId;
  Null? heightUnitName;
  Null? heightUnitType;
  Null? weightUnitId;
  Null? weightUnitName;
  Null? weightUnitType;
  int? totalFollowers;
  int? totalFollowing;
  List<Categories>? categories;
  Null? fitnessLevel;
  Null? planToUse;

  Data(
      {this.userId,
        this.firstName,
        this.lastName,
        this.profilePhoto,
        this.city,
        this.state,
        this.country,
        this.address,
        this.gender,
        this.dob,
        this.bio,
        this.height,
        this.weight,
        this.heightUnitId,
        this.heightUnitName,
        this.heightUnitType,
        this.weightUnitId,
        this.weightUnitName,
        this.weightUnitType,
        this.totalFollowers,
        this.totalFollowing,
        this.categories,
        this.fitnessLevel,
        this.planToUse});

  Data.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    profilePhoto = json['profile_photo'];
    city = json['city'];
    state = json['state'];
    country = json['country'];
    address = json['address'];
    gender = json['gender'];
    dob = json['dob'];
    bio = json['bio'];
    height = json['height'];
    weight = json['weight'];
    heightUnitId = json['height_unit_id'];
    heightUnitName = json['height_unit_name'];
    heightUnitType = json['height_unit_type'];
    weightUnitId = json['weight_unit_id'];
    weightUnitName = json['weight_unit_name'];
    weightUnitType = json['weight_unit_type'];
    totalFollowers = json['total_followers'];
    totalFollowing = json['total_following'];
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(new Categories.fromJson(v));
      });
    }
    fitnessLevel = json['fitness_level'];
    planToUse = json['plan_to_use'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['profile_photo'] = this.profilePhoto;
    data['city'] = this.city;
    data['state'] = this.state;
    data['country'] = this.country;
    data['address'] = this.address;
    data['gender'] = this.gender;
    data['dob'] = this.dob;
    data['bio'] = this.bio;
    data['height'] = this.height;
    data['weight'] = this.weight;
    data['height_unit_id'] = this.heightUnitId;
    data['height_unit_name'] = this.heightUnitName;
    data['height_unit_type'] = this.heightUnitType;
    data['weight_unit_id'] = this.weightUnitId;
    data['weight_unit_name'] = this.weightUnitName;
    data['weight_unit_type'] = this.weightUnitType;
    data['total_followers'] = this.totalFollowers;
    data['total_following'] = this.totalFollowing;
    if (this.categories != null) {
      data['categories'] = this.categories!.map((v) => v.toJson()).toList();
    }
    data['fitness_level'] = this.fitnessLevel;
    data['plan_to_use'] = this.planToUse;
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
