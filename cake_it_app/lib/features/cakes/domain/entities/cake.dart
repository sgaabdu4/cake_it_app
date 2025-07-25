/// Cake entity representing the business logic model
class Cake {
  const Cake({
    required this.title,
    required this.description,
    required this.imageUrl,
  });

  final String title;
  final String description;
  final String imageUrl;

  @override
  String toString() => 'Cake(title: $title, description: $description, imageUrl: $imageUrl)';
}
