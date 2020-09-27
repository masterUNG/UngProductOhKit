class UngDocumentModel {
  List<String> pathImages;

  UngDocumentModel({this.pathImages});

  UngDocumentModel.fromJson(Map<String, dynamic> json) {
    print('json[pathImage]  ==>> ${json["pathImage"]}');
    var result = json['pathImage'];
    for (var item in result) {
      pathImages.add(item);
    }
    // pathImages = json['pathImage'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = Map();
    data['pathImage'] = this.pathImages;
    return data;
  }
}
