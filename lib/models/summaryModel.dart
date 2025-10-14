// class SummaryModel {
//   bool? status;
//   int? statusCode;
//   String? message;
//   Null? errorMessage;
//   Data? data;
//
//   SummaryModel(
//       {this.status,
//         this.statusCode,
//         this.message,
//         this.errorMessage,
//         this.data});
//
//   SummaryModel.fromJson(Map<String, dynamic> json) {
//     status = json['status'];
//     statusCode = json['status_code'];
//     message = json['message'];
//     errorMessage = json['error_message'];
//     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['status'] = this.status;
//     data['status_code'] = this.statusCode;
//     data['message'] = this.message;
//     data['error_message'] = this.errorMessage;
//     if (this.data != null) {
//       data['data'] = this.data!.toJson();
//     }
//     return data;
//   }
// }
//
// class Data {
//   List<ThisWeekActivities>? thisWeekActivities;
//   List<UserChallenges>? userChallenges;
//   List<UserTrophies>? userTrophies;
//
//   Data({this.thisWeekActivities, this.userChallenges, this.userTrophies});
//
//   Data.fromJson(Map<String, dynamic> json) {
//     if (json['this_week_activities'] != null) {
//       thisWeekActivities = <ThisWeekActivities>[];
//       json['this_week_activities'].forEach((v) {
//         thisWeekActivities!.add(new ThisWeekActivities.fromJson(v));
//       });
//     }
//     if (json['user_challenges'] != null) {
//       userChallenges = <UserChallenges>[];
//       json['user_challenges'].forEach((v) {
//         userChallenges!.add(new UserChallenges.fromJson(v));
//       });
//     }
//     if (json['user_trophies'] != null) {
//       userTrophies = <UserTrophies>[];
//       json['user_trophies'].forEach((v) {
//         userTrophies!.add(new UserTrophies.fromJson(v));
//       });
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     if (this.thisWeekActivities != null) {
//       data['this_week_activities'] =
//           this.thisWeekActivities!.map((v) => v.toJson()).toList();
//     }
//     if (this.userChallenges != null) {
//       data['user_challenges'] =
//           this.userChallenges!.map((v) => v.toJson()).toList();
//     }
//     if (this.userTrophies != null) {
//       data['user_trophies'] =
//           this.userTrophies!.map((v) => v.toJson()).toList();
//     }
//     return data;
//   }
// }
//
// class ThisWeekActivities {
//   String? elavationGain;
//   String? distance;
//   int? movingTime;
//   String? pace;
//   String? startDate;
//   String? endDate;
//
//   ThisWeekActivities(
//       {this.elavationGain,
//         this.distance,
//         this.movingTime,
//         this.pace,
//         this.startDate,
//         this.endDate});
//
//   ThisWeekActivities.fromJson(Map<String, dynamic> json) {
//     elavationGain = json['elavation_gain'].toString();
//     distance = json['distance'].toString();
//     movingTime = json['moving_time'];
//     pace = json['pace'].toString();
//     startDate = json['start_date'];
//     endDate = json['end_date'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['elavation_gain'] = this.elavationGain;
//     data['distance'] = this.distance;
//     data['moving_time'] = this.movingTime;
//     data['pace'] = this.pace;
//     data['start_date'] = this.startDate;
//     data['end_date'] = this.endDate;
//     return data;
//   }
// }
//
// class UserChallenges {
//   String? challengeId;
//   String? categoryId;
//   String? categoryName;
//   String? categoryIcon;
//   String? title;
//   String? description;
//   String? startDate;
//   String? endDate;
//   String? challengeType;
//   int? typeValue;
//   String? userId;
//   String? firstName;
//   String? lastName;
//   String? userImage;
//
//   UserChallenges(
//       {this.challengeId,
//         this.categoryId,
//         this.categoryName,
//         this.categoryIcon,
//         this.title,
//         this.description,
//         this.startDate,
//         this.endDate,
//         this.challengeType,
//         this.typeValue,
//         this.userId,
//         this.firstName,
//         this.lastName,
//         this.userImage});
//
//   UserChallenges.fromJson(Map<String, dynamic> json) {
//     challengeId = json['challenge_id'];
//     categoryId = json['category_id'];
//     categoryName = json['category_name'];
//     categoryIcon = json['category_icon'];
//     title = json['title'];
//     description = json['description'];
//     startDate = json['start_date'];
//     endDate = json['end_date'];
//     challengeType = json['challenge_type'];
//     typeValue = json['type_value'];
//     userId = json['user_id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     userImage = json['user_image'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['challenge_id'] = this.challengeId;
//     data['category_id'] = this.categoryId;
//     data['category_name'] = this.categoryName;
//     data['category_icon'] = this.categoryIcon;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['start_date'] = this.startDate;
//     data['end_date'] = this.endDate;
//     data['challenge_type'] = this.challengeType;
//     data['type_value'] = this.typeValue;
//     data['user_id'] = this.userId;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['user_image'] = this.userImage;
//     return data;
//   }
// }
//
// class UserTrophies {
//   String? userTrophyId;
//   String? userId;
//   String? firstName;
//   String? lastName;
//   String? userImage;
//   String? challengeId;
//   String? title;
//   String? description;
//   String? categoryId;
//   String? categoryName;
//   String? categoryIcon;
//
//   UserTrophies(
//       {this.userTrophyId,
//         this.userId,
//         this.firstName,
//         this.lastName,
//         this.userImage,
//         this.challengeId,
//         this.title,
//         this.description,
//         this.categoryId,
//         this.categoryName,
//         this.categoryIcon});
//
//   UserTrophies.fromJson(Map<String, dynamic> json) {
//     userTrophyId = json['user_trophy_id'];
//     userId = json['user_id'];
//     firstName = json['first_name'];
//     lastName = json['last_name'];
//     userImage = json['user_image'];
//     challengeId = json['challenge_id'];
//     title = json['title'];
//     description = json['description'];
//     categoryId = json['category_id'];
//     categoryName = json['category_name'];
//     categoryIcon = json['category_icon'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['user_trophy_id'] = this.userTrophyId;
//     data['user_id'] = this.userId;
//     data['first_name'] = this.firstName;
//     data['last_name'] = this.lastName;
//     data['user_image'] = this.userImage;
//     data['challenge_id'] = this.challengeId;
//     data['title'] = this.title;
//     data['description'] = this.description;
//     data['category_id'] = this.categoryId;
//     data['category_name'] = this.categoryName;
//     data['category_icon'] = this.categoryIcon;
//     return data;
//   }
// }
//
//
// // class SummaryModel {
// //   bool? status;
// //   int? statusCode;
// //   String? message;
// //   Null? errorMessage;
// //   Data? data;
// //
// //   SummaryModel(
// //       {this.status,
// //         this.statusCode,
// //         this.message,
// //         this.errorMessage,
// //         this.data});
// //
// //   SummaryModel.fromJson(Map<String, dynamic> json) {
// //     status = json['status'];
// //     statusCode = json['status_code'];
// //     message = json['message'];
// //     errorMessage = json['error_message'];
// //     data = json['data'] != null ? new Data.fromJson(json['data']) : null;
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['status'] = this.status;
// //     data['status_code'] = this.statusCode;
// //     data['message'] = this.message;
// //     data['error_message'] = this.errorMessage;
// //     if (this.data != null) {
// //       data['data'] = this.data!.toJson();
// //     }
// //     return data;
// //   }
// // }
// //
// // class Data {
// //   List<ThisWeekActivities>? thisWeekActivities;
// //   List<UserChallenges>? userChallenges;
// //   List<UserTrophies>? userTrophies;
// //
// //   Data({this.thisWeekActivities, this.userChallenges, this.userTrophies});
// //
// //   Data.fromJson(Map<String, dynamic> json) {
// //     if (json['this_week_activities'] != null) {
// //       thisWeekActivities = <ThisWeekActivities>[];
// //       json['this_week_activities'].forEach((v) {
// //         thisWeekActivities!.add(new ThisWeekActivities.fromJson(v));
// //       });
// //     }
// //     if (json['user_challenges'] != null) {
// //       userChallenges = <UserChallenges>[];
// //       json['user_challenges'].forEach((v) {
// //         userChallenges!.add(new UserChallenges.fromJson(v));
// //       });
// //     }
// //     if (json['user_trophies'] != null) {
// //       userTrophies = <UserTrophies>[];
// //       json['user_trophies'].forEach((v) {
// //         userTrophies!.add(new UserTrophies.fromJson(v));
// //       });
// //     }
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     if (this.thisWeekActivities != null) {
// //       data['this_week_activities'] =
// //           this.thisWeekActivities!.map((v) => v.toJson()).toList();
// //     }
// //     if (this.userChallenges != null) {
// //       data['user_challenges'] =
// //           this.userChallenges!.map((v) => v.toJson()).toList();
// //     }
// //     if (this.userTrophies != null) {
// //       data['user_trophies'] =
// //           this.userTrophies!.map((v) => v.toJson()).toList();
// //     }
// //     return data;
// //   }
// // }
// //
// // class ThisWeekActivities {
// //   String? firstName;
// //   String? userId;
// //   String? lastName;
// //   String? userImage;
// //   String? categoryId;
// //   String? activityId;
// //   String? categoryName;
// //   String? categoryIcon;
// //   String? title;
// //   String? description;
// //   String? photo;
// //   String? distance;
// //   String? pace;
// //   int? movingTime;
// //   String? location;
// //   String? elavationGain;
// //   String? maxElavation;
// //   int? steps;
// //   double? fastestSplit;
// //   List<Path>? path;
// //   String? runType;
// //   String? typeOfRun;
// //   String? feeling;
// //   Null? privateNote;
// //   String? gear;
// //   String? visibility;
// //   String? hiddenDetails;
// //   bool? muteActivity;
// //   String? type;
// //   double? avgElapsedPace;
// //   double? elapsedTime;
// //   double? maxSpeed;
// //   String? createdDate;
// //
// //   ThisWeekActivities(
// //       {this.firstName,
// //         this.userId,
// //         this.lastName,
// //         this.userImage,
// //         this.categoryId,
// //         this.activityId,
// //         this.categoryName,
// //         this.categoryIcon,
// //         this.title,
// //         this.description,
// //         this.photo,
// //         this.distance,
// //         this.pace,
// //         this.movingTime,
// //         this.location,
// //         this.elavationGain,
// //         this.maxElavation,
// //         this.steps,
// //         this.fastestSplit,
// //         this.path,
// //         this.runType,
// //         this.typeOfRun,
// //         this.feeling,
// //         this.privateNote,
// //         this.gear,
// //         this.visibility,
// //         this.hiddenDetails,
// //         this.muteActivity,
// //         this.type,
// //         this.avgElapsedPace,
// //         this.elapsedTime,
// //         this.maxSpeed,
// //         this.createdDate});
// //
// //   ThisWeekActivities.fromJson(Map<String, dynamic> json) {
// //     firstName = json['first_name'];
// //     userId = json['user_id'];
// //     lastName = json['last_name'];
// //     userImage = json['user_image'];
// //     categoryId = json['category_id'];
// //     activityId = json['activity_id'];
// //     categoryName = json['category_name'];
// //     categoryIcon = json['category_icon'];
// //     title = json['title'];
// //     description = json['description'];
// //     photo = json['photo'];
// //     distance = json['distance'].toString();
// //     pace = json['pace'].toString();
// //     movingTime = json['moving_time'];
// //     location = json['location'];
// //     elavationGain = json['elavation_gain'].toString();
// //     maxElavation = json['max_elavation'].toString();
// //     steps = json['steps'];
// //     fastestSplit = json['fastest_split'];
// //     if (json['path'] != null) {
// //       path = <Path>[];
// //       json['path'].forEach((v) {
// //         path!.add(new Path.fromJson(v));
// //       });
// //     }
// //     runType = json['run_type'];
// //     typeOfRun = json['type_of_run'];
// //     feeling = json['feeling'];
// //     privateNote = json['private_note'];
// //     gear = json['gear'];
// //     visibility = json['visibility'];
// //     hiddenDetails = json['hidden_details'];
// //     muteActivity = json['mute_activity'];
// //     type = json['type'];
// //     avgElapsedPace = json['avg_elapsed_pace'];
// //     elapsedTime = json['elapsed_time'];
// //     maxSpeed = json['max_speed'];
// //     createdDate = json['created_date'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['first_name'] = this.firstName;
// //     data['user_id'] = this.userId;
// //     data['last_name'] = this.lastName;
// //     data['user_image'] = this.userImage;
// //     data['category_id'] = this.categoryId;
// //     data['activity_id'] = this.activityId;
// //     data['category_name'] = this.categoryName;
// //     data['category_icon'] = this.categoryIcon;
// //     data['title'] = this.title;
// //     data['description'] = this.description;
// //     data['photo'] = this.photo;
// //     data['distance'] = this.distance;
// //     data['pace'] = this.pace;
// //     data['moving_time'] = this.movingTime;
// //     data['location'] = this.location;
// //     data['elavation_gain'] = this.elavationGain;
// //     data['max_elavation'] = this.maxElavation;
// //     data['steps'] = this.steps;
// //     data['fastest_split'] = this.fastestSplit;
// //     if (this.path != null) {
// //       data['path'] = this.path!.map((v) => v.toJson()).toList();
// //     }
// //     data['run_type'] = this.runType;
// //     data['type_of_run'] = this.typeOfRun;
// //     data['feeling'] = this.feeling;
// //     data['private_note'] = this.privateNote;
// //     data['gear'] = this.gear;
// //     data['visibility'] = this.visibility;
// //     data['hidden_details'] = this.hiddenDetails;
// //     data['mute_activity'] = this.muteActivity;
// //     data['type'] = this.type;
// //     data['avg_elapsed_pace'] = this.avgElapsedPace;
// //     data['elapsed_time'] = this.elapsedTime;
// //     data['max_speed'] = this.maxSpeed;
// //     data['created_date'] = this.createdDate;
// //     return data;
// //   }
// // }
// //
// // class Path {
// //   String? latitude;
// //   String? longitude;
// //
// //   Path({this.latitude, this.longitude});
// //
// //   Path.fromJson(Map<String, dynamic> json) {
// //     latitude = json['latitude'];
// //     longitude = json['longitude'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['latitude'] = this.latitude;
// //     data['longitude'] = this.longitude;
// //     return data;
// //   }
// // }
// //
// // class UserChallenges {
// //   String? challengeId;
// //   String? categoryId;
// //   String? categoryName;
// //   String? categoryIcon;
// //   String? title;
// //   String? description;
// //   String? startDate;
// //   String? endDate;
// //   String? challengeType;
// //   int? typeValue;
// //   String? userId;
// //   String? firstName;
// //   String? lastName;
// //   String? userImage;
// //
// //   UserChallenges(
// //       {this.challengeId,
// //         this.categoryId,
// //         this.categoryName,
// //         this.categoryIcon,
// //         this.title,
// //         this.description,
// //         this.startDate,
// //         this.endDate,
// //         this.challengeType,
// //         this.typeValue,
// //         this.userId,
// //         this.firstName,
// //         this.lastName,
// //         this.userImage});
// //
// //   UserChallenges.fromJson(Map<String, dynamic> json) {
// //     challengeId = json['challenge_id'];
// //     categoryId = json['category_id'];
// //     categoryName = json['category_name'];
// //     categoryIcon = json['category_icon'];
// //     title = json['title'];
// //     description = json['description'];
// //     startDate = json['start_date'];
// //     endDate = json['end_date'];
// //     challengeType = json['challenge_type'];
// //     typeValue = json['type_value'];
// //     userId = json['user_id'];
// //     firstName = json['first_name'];
// //     lastName = json['last_name'];
// //     userImage = json['user_image'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['challenge_id'] = this.challengeId;
// //     data['category_id'] = this.categoryId;
// //     data['category_name'] = this.categoryName;
// //     data['category_icon'] = this.categoryIcon;
// //     data['title'] = this.title;
// //     data['description'] = this.description;
// //     data['start_date'] = this.startDate;
// //     data['end_date'] = this.endDate;
// //     data['challenge_type'] = this.challengeType;
// //     data['type_value'] = this.typeValue;
// //     data['user_id'] = this.userId;
// //     data['first_name'] = this.firstName;
// //     data['last_name'] = this.lastName;
// //     data['user_image'] = this.userImage;
// //     return data;
// //   }
// // }
// //
// // class UserTrophies {
// //   String? userTrophyId;
// //   String? userId;
// //   String? firstName;
// //   String? lastName;
// //   String? userImage;
// //   String? challengeId;
// //   String? title;
// //   String? description;
// //   String? categoryId;
// //   String? categoryName;
// //   String? categoryIcon;
// //
// //   UserTrophies(
// //       {this.userTrophyId,
// //         this.userId,
// //         this.firstName,
// //         this.lastName,
// //         this.userImage,
// //         this.challengeId,
// //         this.title,
// //         this.description,
// //         this.categoryId,
// //         this.categoryName,
// //         this.categoryIcon});
// //
// //   UserTrophies.fromJson(Map<String, dynamic> json) {
// //     userTrophyId = json['user_trophy_id'];
// //     userId = json['user_id'];
// //     firstName = json['first_name'];
// //     lastName = json['last_name'];
// //     userImage = json['user_image'];
// //     challengeId = json['challenge_id'];
// //     title = json['title'];
// //     description = json['description'];
// //     categoryId = json['category_id'];
// //     categoryName = json['category_name'];
// //     categoryIcon = json['category_icon'];
// //   }
// //
// //   Map<String, dynamic> toJson() {
// //     final Map<String, dynamic> data = new Map<String, dynamic>();
// //     data['user_trophy_id'] = this.userTrophyId;
// //     data['user_id'] = this.userId;
// //     data['first_name'] = this.firstName;
// //     data['last_name'] = this.lastName;
// //     data['user_image'] = this.userImage;
// //     data['challenge_id'] = this.challengeId;
// //     data['title'] = this.title;
// //     data['description'] = this.description;
// //     data['category_id'] = this.categoryId;
// //     data['category_name'] = this.categoryName;
// //     data['category_icon'] = this.categoryIcon;
// //     return data;
// //   }
// // }


class SummaryModel {
  bool? status;
  int? statusCode;
  String? message;
  Null? errorMessage;
  Data? data;

  SummaryModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  SummaryModel.fromJson(Map<String, dynamic> json) {
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
  List<ThisWeekActivities>? thisWeekActivities;
  List<UserChallenges>? userChallenges;
  List<UserTrophies>? userTrophies;

  Data({this.thisWeekActivities, this.userChallenges, this.userTrophies});

  Data.fromJson(Map<String, dynamic> json) {
    if (json['this_week_activities'] != null) {
      thisWeekActivities = <ThisWeekActivities>[];
      json['this_week_activities'].forEach((v) {
        thisWeekActivities!.add(new ThisWeekActivities.fromJson(v));
      });
    }
    if (json['user_challenges'] != null) {
      userChallenges = <UserChallenges>[];
      json['user_challenges'].forEach((v) {
        userChallenges!.add(new UserChallenges.fromJson(v));
      });
    }
    if (json['user_trophies'] != null) {
      userTrophies = <UserTrophies>[];
      json['user_trophies'].forEach((v) {
        userTrophies!.add(new UserTrophies.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.thisWeekActivities != null) {
      data['this_week_activities'] =
          this.thisWeekActivities!.map((v) => v.toJson()).toList();
    }
    if (this.userChallenges != null) {
      data['user_challenges'] =
          this.userChallenges!.map((v) => v.toJson()).toList();
    }
    if (this.userTrophies != null) {
      data['user_trophies'] =
          this.userTrophies!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ThisWeekActivities {
  String? elavationGain;
  String? distance;
  String? movingTime;
  String? pace;
  String? startDate;
  String? endDate;

  ThisWeekActivities(
      {this.elavationGain,
        this.distance,
        this.movingTime,
        this.pace,
        this.startDate,
        this.endDate});

  ThisWeekActivities.fromJson(Map<String, dynamic> json) {
    elavationGain = json['elavation_gain'].toString();
    distance = json['distance'].toString();
    movingTime = json['moving_time'].toString();
    pace = json['pace'].toString();
    startDate = json['start_date'];
    endDate = json['end_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['elavation_gain'] = this.elavationGain;
    data['distance'] = this.distance;
    data['moving_time'] = this.movingTime;
    data['pace'] = this.pace;
    data['start_date'] = this.startDate;
    data['end_date'] = this.endDate;
    return data;
  }
}

class UserChallenges {
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

  UserChallenges(
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

  UserChallenges.fromJson(Map<String, dynamic> json) {
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

class UserTrophies {
  String? userTrophyId;
  String? userId;
  String? firstName;
  String? lastName;
  String? userImage;
  String? categoryId;
  String? categoryName;
  String? categoryIcon;
  String? challengeId;
  String? title;
  String? description;
  String? challengeValue;
  String? challengeIcon;
  String? trophyIcon;

  UserTrophies(
      {this.userTrophyId,
        this.userId,
        this.firstName,
        this.lastName,
        this.userImage,
        this.categoryId,
        this.categoryName,
        this.categoryIcon,
        this.challengeId,
        this.title,
        this.description,
        this.challengeValue,
        this.challengeIcon,
        this.trophyIcon});

  UserTrophies.fromJson(Map<String, dynamic> json) {
    userTrophyId = json['user_trophy_id'];
    userId = json['user_id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    userImage = json['user_image'];
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    categoryIcon = json['category_icon'];
    challengeId = json['challenge_id'];
    title = json['title'];
    description = json['description'];
    challengeValue = json['challenge_value'];
    challengeIcon = json['challenge_icon'];
    trophyIcon = json['trophy_icon'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_trophy_id'] = this.userTrophyId;
    data['user_id'] = this.userId;
    data['first_name'] = this.firstName;
    data['last_name'] = this.lastName;
    data['user_image'] = this.userImage;
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['category_icon'] = this.categoryIcon;
    data['challenge_id'] = this.challengeId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['challenge_value'] = this.challengeValue;
    data['challenge_icon'] = this.challengeIcon;
    data['trophy_icon'] = this.trophyIcon;
    return data;
  }
}
