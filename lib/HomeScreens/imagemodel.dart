// ignore_for_file: public_member_api_docs, sort_constructors_first
class ImageModel {
  final String name;
  final String path;
   String? url; // Simulated URL after upload

  ImageModel({
    required this.name,
    required this.path,
    this.url,
  });

  ImageModel copyWith({
    String? name,
    String? path,
    String? url,
  }) {
    return ImageModel(
      name: name ?? this.name,
      path: path ?? this.path,
      url: url ?? this.url,
    );
  }
}
