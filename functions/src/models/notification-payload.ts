export class NotificationPayload {
    constructor(
        public fullName: string,
        public image: string,
        public message: string,
        public target: string,
    ) { }
}
