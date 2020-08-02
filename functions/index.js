const functions = require('firebase-functions');
const admin = require('firebase-admin');

admin.initializeApp();

exports.sendNotification = functions.firestore.document('news/{uid}').onCreate((snapshot, context) => {
    const fcm = admin.messaging();
    const news = snapshot.data();
    const title = news['title'];
    console.log(title);
    console.log(news);
    const topic = 'news';
    const payload = {
        notification: {
            title: 'Notify',
            body: String(title),
        },
        data: {
            sound: 'default',
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
        }
    };

    fcm.sendToTopic(topic, payload);

    return Promise.resolve();

});