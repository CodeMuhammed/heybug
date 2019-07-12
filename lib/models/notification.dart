import 'package:flutter/foundation.dart';

class NotificationPayload {
  final String fullName;
  final String image;
  final String message;
  final String target;

  NotificationPayload({
    @required this.fullName,
    @required this.message,
    @required this.image,
    @required this.target,
  });

  Map<String, dynamic> toJSon() {
    return {
      'fullName': this.fullName,
      'image': this.image,
      'message': this.message,
      'target': this.target,
    };
  }
}
