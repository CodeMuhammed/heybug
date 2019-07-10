import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(nullable: false)
class User {
  final String id;
  final String firstName;
  final String lastName;
  final String uid;
  final String email;

  User({this.firstName, this.lastName, this.uid, this.email, this.id});

  User fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      uid: json['uid'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJSon() {
    final userJson = {
      'firstName': this.firstName,
      'lastName': this.lastName,
      'uid': this.uid,
      'email': this.email,
    };

    if (this.id != null) {
      userJson['id'] = this.id;
    }

    return userJson;
  }
}
