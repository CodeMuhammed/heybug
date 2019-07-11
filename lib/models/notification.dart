import 'package:flutter/foundation.dart';

class NotificationPayload {
  final String fullName;
  final String image;
  final String message;

  NotificationPayload({@required this.fullName, @required this.message, @required this.image});

  Map<String, dynamic> toJSon() {
    return {
      'fullName': this.fullName,
      'image': this.image,
      'message': this.message,
    };
  }
}
