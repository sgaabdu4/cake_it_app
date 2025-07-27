import 'package:cake_it_app/features/cakes/domain/entities/cake.dart';

// data transfer object - replaces direct json handling in ui from initial repo
class CakeModel {
  const CakeModel({
    this.title,
    this.description,
    this.image,
  });

  final String? title;
  final String? description;
  final String? image;

  factory CakeModel.fromJson(Map<String, dynamic> json) {
    return CakeModel(
      title: json['title']?.toString() ?? '',
      description: json['desc']?.toString() ?? '',
      image: json['image']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': description,
      'image': image,
    };
  }

  Cake toEntity() {
    return Cake(
      title: title ?? '',
      description: description ?? '',
      imageUrl: image ?? '',
    );
  }
}
