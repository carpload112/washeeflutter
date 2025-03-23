class Service {
  final String id;
  final String name;
  final String description;
  final double price;
  final int duration; // in minutes
  final String imageUrl;

  Service({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.imageUrl,
  });
}

