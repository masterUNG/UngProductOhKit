class UserModel {
  String name;
  String position;
  String urlAvatar;

  UserModel({this.name, this.position, this.urlAvatar});

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    position = json['Position'];
    urlAvatar = json['UrlAvatar'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Name'] = this.name;
    data['Position'] = this.position;
    data['UrlAvatar'] = this.urlAvatar;
    return data;
  }
}
