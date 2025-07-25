/// A placeholder class that represents an entity or model.

// TODO(Abid): Does this need changing?
class Cake {
  const Cake({
    this.title,
    this.description,
    this.image,
  });

  final String? title;
  final String? description;
  final String? image;

  factory Cake.fromJson(Map<String, dynamic> json) {
    return Cake(
      title: json['title'],
      description: json['desc'],
      image: json['image'],
    );
    // TODO(Abid): No validation or sanitisation
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'desc': description,
      'image': image,
    };
  }
}
