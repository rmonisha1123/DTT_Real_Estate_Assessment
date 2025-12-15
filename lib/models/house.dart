/// Data model representing a house listing.
///
/// Contains property details such as price, location, size,
/// and descriptive information retrieved from the API.
class House {
  final int id;
  final String title;
  final String imagePath;
  final double price;
  final String city;
  final String postalCode;
  final int bedrooms;
  final int bathrooms;
  final int size;
  final double latitude;
  final double longitude;
  final double? distance;
  final String? description;

  House({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.price,
    required this.city,
    required this.postalCode,
    required this.bedrooms,
    required this.bathrooms,
    required this.size,
    required this.latitude,
    required this.longitude,
    this.distance,
    this.description,
  });

  factory House.fromJson(Map<String, dynamic> json) {
    return House(
      id: json['id'],
      title: json['title'] ?? '',
      imagePath: json['image'] ?? '',
      price: double.tryParse(json['price'].toString()) ?? 0.0,
      city: json['city'] ?? '',
      postalCode: (json['zip'] ?? '').toString().replaceAll(' ', ''),
      bedrooms: json['bedrooms'] ?? 0,
      bathrooms: json['bathrooms'] ?? 0,
      size: json['size'] ?? 0,
      latitude: (json['latitude'] ?? 0).toDouble(),
      longitude: (json['longitude'] ?? 0).toDouble(),
      distance: (json['distance'] != null)
          ? double.tryParse(json['distance'].toString())
          : null,
      description: json['description'],
    );
  }

  House copyWith({double? distance}) {
    return House(
      id: id,
      title: title,
      imagePath: imagePath,
      price: price,
      city: city,
      postalCode: postalCode,
      bedrooms: bedrooms,
      bathrooms: bathrooms,
      size: size,
      latitude: latitude,
      longitude: longitude,
      distance: distance ?? this.distance,
      description: description,
    );
  }

  // For saving to SharedPreferences
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': imagePath,
      'price': price,
      'city': city,
      'zip': postalCode,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'size': size,
      'latitude': latitude,
      'longitude': longitude,
      'description': description,
      'distance': distance,
    };
  }

  // For restoring from SharedPreferences (alias for fromJson)
  static House fromMap(Map<String, dynamic> map) => House.fromJson(map);

  // Full image URL getter
  String get imageUrl => 'https://intern.d-tt.nl$imagePath';
}
