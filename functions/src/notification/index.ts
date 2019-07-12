import * as functions from 'firebase-functions';
import { NotificationPayload } from '../models';

// setup the firebase admin app
import * as admin from 'firebase-admin';
admin.initializeApp();

const fcm = admin.messaging();
const defaultLogo = 'https://firebasestorage.googleapis.com/v0/b/hey-bug.appspot.com/o/hey-bug.png?alt=media&token=88d93291-dd62-4090-84f5-706fee44df3f';

export const sendNotificationHandler = functions.https.onCall(async (data: NotificationPayload, context) => {
    if (!context.auth) {
        // Throwing an HttpsError so that the client gets the error details.
        throw new functions.https.HttpsError('failed-precondition', 'The function must be called ' +
            'while authenticated.');
    } else {
        const payload: admin.messaging.MessagingPayload = {
            notification: {
                title: `Message from ${data.fullName}`,
                body: data.message,
                icon: data.image || defaultLogo,
                click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
        };

        if (data.target) {
            try {
                await fcm.sendToDevice([data.target], payload);
            } catch (e) {
                console.log(e);
            }
        }

        return { message: 'success' };
    }
});
