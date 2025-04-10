// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';
import 'dart:core';

class UserModel {
  String? name;
  String? des;
  String? price;
  String? catg;
  bool? allownotification;
   String? imageurl;
   String? id;
  UserModel({
    this.name,
    this.des,
    this.price,
    this.catg,
    this.allownotification,
    this.imageurl,
    this.id,
  });

  UserModel copyWith({
    String? name,
    String? des,
    String? price,
    String? catg,
    bool? allownotification,
    String? imageurl,
    String? id,
  }) {
    return UserModel(
      name: name ?? this.name,
      des: des ?? this.des,
      price: price ?? this.price,
      catg: catg ?? this.catg,
      allownotification: allownotification ?? this.allownotification,
      imageurl: imageurl ?? this.imageurl,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'des': des,
      'price': price,
      'catg': catg,
      'allownotification': allownotification,
      'imageurl': imageurl,
      'id': id,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] != null ? map['name'] as String : null,
      des: map['des'] != null ? map['des'] as String : null,
      price: map['price'] != null ? map['price'] as String : null,
      catg: map['catg'] != null ? map['catg'] as String : null,
      allownotification: map['allownotification'] != null ? map['allownotification'] as bool : null,
      imageurl: map['imageurl'] != null ? map['imageurl'] as String : null,
      id: map['id'] != null ? map['id'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) => UserModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'UserModel(name: $name, des: $des, price: $price, catg: $catg, allownotification: $allownotification, imageurl: $imageurl, id: $id)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;
  
    return 
      other.name == name &&
      other.des == des &&
      other.price == price &&
      other.catg == catg &&
      other.allownotification == allownotification &&
      other.imageurl == imageurl &&
      other.id == id;
  }

  @override
  int get hashCode {
    return name.hashCode ^
      des.hashCode ^
      price.hashCode ^
      catg.hashCode ^
      allownotification.hashCode ^
      imageurl.hashCode ^
      id.hashCode;
  }
}
