import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileData {
  ProfileData({
    this.id,
    this.uuid,
    this.username,
    this.email,
    this.phone,
    this.birthday,
    this.gender,
    this.registeredAt,
    this.active,
    this.img,
  });

  int? id;
  String? uuid;
  String? username;
  String? email;
  String? phone;
  String? birthday;
  String? gender;
  String? registeredAt;
  bool? active;
  String? img;

  ProfileData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    uuid = json['uuid'];
    username = json['username'];
    email = json['email'];
    phone = json['phone'];
    birthday = json['birthday'];
    gender = json['gender'];
    registeredAt = json['registered_at'];
    active = json['active'] is int ? (json['active'] == 1) : json['active'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['uuid'] = uuid;
    map['username'] = username;
    map['email'] = email;
    map['phone'] = phone;
    if (birthday != null) {
      map['birthday'] = birthday;
    }
    if (gender != null) {
      map['gender'] = gender;
    }
    map['registered_at'] = registeredAt;
    map['active'] = active;
    map['img'] = img;

    return map;
  }

  ProfileData copyWith({
    int? id,
    String? uuid,
    String? username,
    String? email,
    String? phone,
    String? birthday,
    String? gender,
    String? registeredAt,
    bool? active,
    String? img,
  }) {
    return ProfileData(
      id: id ?? this.id,
      uuid: uuid ?? this.uuid,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      birthday: birthday ?? this.birthday,
      gender: gender ?? this.gender,
      registeredAt: registeredAt ?? this.registeredAt,
      active: active ?? this.active,
      img: img ?? this.img,
    );
  }

  factory ProfileData.fromDocumentSnapshot(DocumentSnapshot doc) {
    return ProfileData.fromJson(doc.data() as Map<String, dynamic>);
  }
}
