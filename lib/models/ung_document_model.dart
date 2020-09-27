class UngDocumentModel {
  List<String> pathImages;

  UngDocumentModel(this.pathImages);

  UngDocumentModel.fromJson(Map<String, dynamic> json) {
    pathImages = json['pathImage'];
  }

  Map<String, dynamic> toJSON() {
    final Map<String, dynamic> data = Map();
    data['pathImage'] = this.pathImages;
    return data;
  }
}
