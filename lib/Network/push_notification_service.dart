import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class PushNotificationService {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static String token;
  static StreamController<Map> _messageStream =
      new StreamController.broadcast();
  static Stream<Map> get messagesStream => _messageStream.stream;

  static Future _onBackgroundHandler(RemoteMessage message) async {
    print("background Handler ${message.messageId}");
    _messageStream.add(message.data ?? 'No data');
  }

  static Future _onMessagedHandler(RemoteMessage message) async {
    print("message Handler ${message.messageId}");
    // _messageStream.add(message.data['category'] ?? 'No data');

    // Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) => NewsPage(
    //         // news: widget.news,
    //         )));

    // Navigator.pushNamed(context, "NewsPage");
    // _redirect("context", BuildContext );
  }

  // static void _redirect(page) {
  //   Navigator.pushNamed(BuildContext path.context, "NewsPage");
  // }

  static Future _onMessageOpenHandler(RemoteMessage message) async {
    print("background Handler ${message.messageId}");
    _messageStream.add(message.data ?? 'No data');
  }

  static Future initializeApp() async {
    await Firebase.initializeApp();
    token = await FirebaseMessaging.instance.getToken();
    // print(token);
    // Handlers
    FirebaseMessaging.onBackgroundMessage(_onBackgroundHandler);
    FirebaseMessaging.onMessage.listen(_onMessagedHandler);
    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenHandler);
    // return token;
  }

  static Future getToken() async {
    token = await FirebaseMessaging.instance.getToken();
    return token;
  }

  static closeStreams() {
    _messageStream.close();
  }
}
