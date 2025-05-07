import 'dart:convert';

class UserModel {
  String? name;
  String? email;
  String? uid;
  double? bakeryRating;
  int? totalRatings;
  String? bakeryName;
  String? bakeryDescription;
  String? bakeryTiming;
  String? bakeryLocation;
  String? bakeryLatLng;
  String? imageurl;

  UserModel({
    this.name,
    this.email,
    this.uid,
    this.bakeryRating,
    this.totalRatings,
    this.bakeryName,
    this.bakeryDescription,
    this.bakeryTiming,
    this.bakeryLocation,
    this.bakeryLatLng,
    this.imageurl,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? uid,
    double? bakeryRating,
    int? totalRatings,
    String? bakeryName,
    String? bakeryDescription,
    String? bakeryTiming,
    String? bakeryLocation,
    String? bakeryLatLng,
    String? imageurl,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      uid: uid ?? this.uid,
      bakeryRating: bakeryRating ?? this.bakeryRating,
      totalRatings: totalRatings ?? this.totalRatings,
      bakeryName: bakeryName ?? this.bakeryName,
      bakeryDescription: bakeryDescription ?? this.bakeryDescription,
      bakeryTiming: bakeryTiming ?? this.bakeryTiming,
      bakeryLocation: bakeryLocation ?? this.bakeryLocation,
      bakeryLatLng: bakeryLatLng ?? this.bakeryLatLng,
      imageurl: imageurl ?? this.imageurl,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'uid': uid,
      'bakeryRating': bakeryRating,
      'totalRatings': totalRatings,
      'bakeryName': bakeryName,
      'bakeryDescription': bakeryDescription,
      'bakeryTiming': bakeryTiming,
      'bakeryLocation': bakeryLocation,
      'bakeryLatLng': bakeryLatLng,
      'imageurl': imageurl,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'],
      email: map['email'],
      uid: map['uid'],
      bakeryRating: map['bakeryRating']?.toDouble(),
      totalRatings: map['totalRatings']?.toInt(),
      bakeryName: map['bakeryName'],
      bakeryDescription: map['bakeryDescription'],
      bakeryTiming: map['bakeryTiming'],
      bakeryLocation: map['bakeryLocation'],
      bakeryLatLng: map['bakeryLatLng'],
      imageurl: map['imageurl'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(name: $name, email: $email, uid: $uid, bakeryRating: $bakeryRating, totalRatings: $totalRatings, bakeryName: $bakeryName, bakeryDescription: $bakeryDescription, bakeryTiming: $bakeryTiming, bakeryLocation: $bakeryLocation, bakeryLatLng: $bakeryLatLng)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    return identical(this, other) ||
        other.name == name &&
            other.email == email &&
            other.uid == uid &&
            other.bakeryRating == bakeryRating &&
            other.totalRatings == totalRatings &&
            other.bakeryName == bakeryName &&
            other.bakeryDescription == bakeryDescription &&
            other.bakeryTiming == bakeryTiming &&
            other.bakeryLocation == bakeryLocation &&
            other.bakeryLatLng == bakeryLatLng &&
            other.imageurl == imageurl;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        uid.hashCode ^
        bakeryRating.hashCode ^
        totalRatings.hashCode ^
        bakeryName.hashCode ^
        bakeryDescription.hashCode ^
        bakeryTiming.hashCode ^
        bakeryLocation.hashCode ^
        bakeryLatLng.hashCode ^
        imageurl.hashCode;
  }
}
