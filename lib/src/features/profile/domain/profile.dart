// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class Profile {
  final String name;
  final String email;
  final String address;
  final String number;
  final String image;
  Timestamp? createdAt;
  Timestamp? updatedAt;

  Profile({
    required this.name,
    required this.email,
    required this.address,
    required this.number,
    required this.image,
    this.createdAt,
    this.updatedAt,
  });

  Profile copyWith({
    String? name,
    String? email,
    String? address,
    String? number,
    String? image,
    Timestamp? createdAt,
    Timestamp? updatedAt,
  }) {
    return Profile(
      name: name ?? this.name,
      email: email ?? this.email,
      address: address ?? this.address,
      number: number ?? this.number,
      image: image ?? this.image,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'address': address,
      'number': number,
      'image': image,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map) {
    return Profile(
      name: map['name'] as String,
      email: map['email'] as String,
      address: map['address'] as String,
      number: map['number'] as String,
      image: map['image'] as String,
      createdAt: map['createdAt'],
      updatedAt: map['updatedAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory Profile.fromJson(String source) =>
      Profile.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Profile(name: $name, email: $email, address: $address, number: $number, image: $image, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(covariant Profile other) {
    if (identical(this, other)) return true;

    return other.name == name &&
        other.email == email &&
        other.address == address &&
        other.number == number &&
        other.image == image &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        address.hashCode ^
        number.hashCode ^
        image.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }
}
