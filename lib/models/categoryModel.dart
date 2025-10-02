class CategoryModel {
  bool? status;
  int? statusCode;
  String? message;
  String? errorMessage;
  List<CategoryModelData>? data;

  CategoryModel(
      {this.status,
        this.statusCode,
        this.message,
        this.errorMessage,
        this.data});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    statusCode = json['status_code'];
    message = json['message'];
    errorMessage = json['error_message'];
    if (json['data'] != null) {
      data = <CategoryModelData>[];
      json['data'].forEach((v) {
        data!.add(new CategoryModelData.fromJson(v));
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

class CategoryModelData {
  String? categoryId;
  String? categoryName;
  String? uniqueCode;
  String? categoryIcon;
  String? backgroundImage;
  String? tips;

  CategoryModelData(
      {this.categoryId,
        this.categoryName,
        this.uniqueCode,
        this.categoryIcon,
        this.backgroundImage,
        this.tips});

  CategoryModelData.fromJson(Map<String, dynamic> json) {
    categoryId = json['category_id'];
    categoryName = json['category_name'];
    uniqueCode = json['unique_code'];
    categoryIcon = json['category_icon'];
    backgroundImage = json['background_image'];
    tips = json['tips'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['category_id'] = this.categoryId;
    data['category_name'] = this.categoryName;
    data['unique_code'] = this.uniqueCode;
    data['category_icon'] = this.categoryIcon;
    data['background_image'] = this.backgroundImage;
    data['tips'] = this.tips;
    return data;
  }
}
