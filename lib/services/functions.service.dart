import 'package:heybug/models/index.dart';
import 'package:cloud_functions/cloud_functions.dart';

class FunctionsService {
  final HttpsCallable sendNotification = CloudFunctions.instance.getHttpsCallable(
    functionName: 'sendNotification',
  );

  Future<HttpsCallableResult> sendNotificationToUser(NotificationPayload payload) {
    return sendNotification.call(payload.toJSon());
  }
}
