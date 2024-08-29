// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'dart:convert';

ImageModel imageModelFromJson(String str) => ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
    bool success;
    int totalPhotos;
    String message;
    int offset;
    int limit;
    List<Photo> photos;

    ImageModel({
        required this.success,
        required this.totalPhotos,
        required this.message,
        required this.offset,
        required this.limit,
        required this.photos,
    });

    factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        success: json["success"],
        totalPhotos: json["total_photos"],
        message: json["message"],
        offset: json["offset"],
        limit: json["limit"],
        photos: List<Photo>.from(json["photos"].map((x) => Photo.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "total_photos": totalPhotos,
        "message": message,
        "offset": offset,
        "limit": limit,
        "photos": List<dynamic>.from(photos.map((x) => x.toJson())),
    };
}

class Photo {
    int id;
    String description;
    String url;
    String title;
    int user;

    Photo({
        required this.id,
        required this.description,
        required this.url,
        required this.title,
        required this.user,
    });

    factory Photo.fromJson(Map<String, dynamic> json) => Photo(
        id: json["id"],
        description: json["description"],
        url: json["url"],
        title: json["title"],
        user: json["user"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "description": description,
        "url": url,
        "title": title,
        "user": user,
    };
}
