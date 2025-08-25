class CommonDataModel {
  String? key;
  String? image;
  String? title;
  String? description;

  CommonDataModel({this.key,this.image,this.title, this.description});

  CommonDataModel.fromJson(Map<String, dynamic> json) {
    key = json['key'];
    image = json['image'];
    title = json['title'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['key'] = this.key;
    data['image'] = this.image;
    data['title'] = this.title;
    data['description'] = this.description;
    return data;
  }
}