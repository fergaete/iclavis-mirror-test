import 'dart:convert';

List<VideoModel> videoModelFromJson(List data) =>
    List<VideoModel>.from(data.map((x) => VideoModel.fromJson(x)));

String videoModelToJson(List<VideoModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class VideoModel {
  VideoModel({
    this.id,
    this.name,
    this.url,
  });

  int? id;
  String? name;
  String? url;

  factory VideoModel.fromJson(Map<String, dynamic> json) => VideoModel(
        id: json["id"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
      };
}
