import 'dart:convert';

List<ImageModel> imageModelFromJson(List data) =>
    List<ImageModel>.from(data.map((x) => ImageModel.fromJson(x)));

String imageModelToJson(List<ImageModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ImageModel {
  ImageModel({
    this.categoryName,
    this.id,
    this.images,
  });

  String? categoryName;
  int? id;
  List<_Image>? images;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        categoryName: json["categoryName"],
        id: json["id"],
        images:
            List<_Image>.from(json["images"].map((x) => _Image.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "categoryName": categoryName,
        "id": id,
        "images": List<dynamic>.from(images!.map((x) => x.toJson())),
      };
}

class _Image {
  _Image({
    this.name,
    this.url,
  });

  String? name;
  String? url;

  factory _Image.fromJson(Map<String, dynamic> json) => _Image(
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "url": url,
      };
}
