// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class QR {
  final String uid;
  final String value;
  Timestamp? inAt;
  Timestamp? outAt;
  QR({
    required this.uid,
    required this.value,
    this.inAt,
    this.outAt,
  });

  QR copyWith({
    String? uid,
    String? value,
    Timestamp? inAt,
    Timestamp? outAt,
  }) {
    return QR(
      uid: uid ?? this.uid,
      value: value ?? this.value,
      inAt: inAt ?? this.inAt,
      outAt: outAt ?? this.outAt,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'value': value,
      'inAt': inAt,
      'outAt': outAt,
    };
  }

  factory QR.fromMap(Map<String, dynamic> map) {
    return QR(
      uid: map['uid'] as String,
      value: map['value'] as String,
      inAt: map['inAt'],
      outAt: map['outAt'],
    );
  }

  String toJson() => json.encode(toMap());

  factory QR.fromJson(String source) =>
      QR.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'QR(uid: $uid, value: $value, inAt: $inAt, outAt: $outAt)';
  }

  @override
  bool operator ==(covariant QR other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.value == value &&
        other.inAt == inAt &&
        other.outAt == outAt;
  }

  @override
  int get hashCode {
    return uid.hashCode ^ value.hashCode ^ inAt.hashCode ^ outAt.hashCode;
  }
}
