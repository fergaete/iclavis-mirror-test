import 'dart:convert';

List<DocumentModel> documentModelFromJson(List data) =>
    List<DocumentModel>.from(data.map((x) => DocumentModel.fromJson(x)));

String documentModelToJson(List<DocumentModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DocumentModel {
  DocumentModel({
    this.id,
    this.categoryName,
    required this.documents,
  });

  int? id;
  String? categoryName;
  List<Document> documents;

  factory DocumentModel.fromJson(Map<String, dynamic> json) => DocumentModel(
        id: json["id"],
        categoryName: json["categoryName"],
        documents: List<Document>.from(
            json["documents"].map((x) => Document.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categoryName": categoryName,
        "documents": List<dynamic>.from(documents.map((x) => x.toJson())),
      };
}

class Document {
  Document({
    this.id,
    this.name,
    this.url,
  });

  int? id;
  String? name;
  String? url;

  factory Document.fromJson(Map<String, dynamic> json) => Document(
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
