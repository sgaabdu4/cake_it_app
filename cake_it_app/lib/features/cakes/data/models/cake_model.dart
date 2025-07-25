// TODO(Abid): Does this need changing?
import 'package:cake_it_app/features/cakes/domain/entities/cake_entity.dart';

/// A placeholder class that represents an entity or model.
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

  /// Converts to domain entity
  Cake toEntity() {
    return Cake(
      title: title ?? '',
      description: description ?? '',
      imageUrl: image ?? '',
    );
  }
}
