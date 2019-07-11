import * as admin from 'firebase-admin';
import { sendNotificationHandler } from './notification';

// setup the firebase admin app
admin.initializeApp();

// listens or send push notifications
export const sendNotification = sendNotificationHandler;