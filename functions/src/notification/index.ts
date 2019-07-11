import * as functions from 'firebase-functions';
import { NotificationPayload } from '../models';

export const sendNotificationHandler = functions.https.onCall((data: NotificationPayload, context) => {
    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    } else {
        console.log(data, context);
        return { message: 'success' };
    }
});
