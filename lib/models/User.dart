import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class User {
  final String id;
  String firstName;
  String lastName;
  String uid;
  String email;
  String picture;
  String fcmToken;
  String fcmPlatform;

  User(
      {this.firstName,
      this.lastName,
      this.uid,
      this.email,
      this.id,
      this.picture,
      this.fcmToken,
      this.fcmPlatform});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      uid: json['uid'],
      email: json['email'],
      picture: json['picture'],
      fcmToken: json['fcmToken'],
      fcmPlatform: json['fcmPlatform'],
    );
  }

  Map<String, dynamic> toJSon() {
    final jsonData = {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'uid': this.uid,
      'email': this.email,
      'picture': this.picture,
      'fcmToken': this.fcmToken,
      'fcmPlatform': this.fcmPlatform,
    };

    if (this.id != null) {
      jsonData['id'] = this.id;
    }

    return jsonData;
  }
}
