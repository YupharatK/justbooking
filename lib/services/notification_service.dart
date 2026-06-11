import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  FirebaseMessaging get _fcm => FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

    // ฟังก์ชันสำหรับเตรียมความพร้อมและขอสิทธิ์การแจ้งเตือน
  Future<void> init() async {
    if (_isInitialized) return;

    if (kIsWeb) {
      if (kDebugMode) {
        print('NotificationService is bypassed on Web.');
      }
      return; // FCM doesn't work well on Flutter Web without service worker setup
    }

    // 1. Request permissions for iOS and Android 13+
    NotificationSettings settings = await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (kDebugMode) {
      print('User granted permission: ${settings.authorizationStatus}');
    }

    // 2. Initialize Local Notifications
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    // For iOS
    const DarwinInitializationSettings iosInitSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _localNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle when user taps on the notification
        if (kDebugMode) {
          print('Notification payload: ${response.payload}');
        }
      },
    );

    // 3. Create Android Notification Channel for Heads-up notifications
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // name
      description: 'This channel is used for important notifications.', // description
      importance: Importance.max,
    );

    await _localNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    // 4. Configure FCM options for foreground display on Apple devices
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // 5. Listen to messages in Foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Got a message whilst in the foreground!');
        print('Message data: ${message.data}');
      }

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;

      // If `onMessage` is triggered with a notification, construct our own
      // local notification to show to users using the created channel.
      if (notification != null && android != null) {
        _localNotificationsPlugin.show(
          id: notification.hashCode,
          title: notification.title,
          body: notification.body,
          notificationDetails: NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channelDescription: channel.description,
              icon: '@mipmap/ic_launcher',
              importance: Importance.max,
              priority: Priority.high,
            ),
            iOS: const DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
            ),
          ),
          payload: message.data.toString(), // Optional: pass data as payload
        );
      }
    });

    // 6. Handle app opening from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('A new onMessageOpenedApp event was published!');
        print('Message data: ${message.data}');
      }
      // Navigate to corresponding screen based on message.data if needed
    });

    _isInitialized = true;
  }

  // Get FCM Token for the current user (to send push notifications later)
    // ฟังก์ชันสำหรับดึง FCM Token ของเครื่องเพื่อใช้ส่ง Push Notification
  Future<String?> getToken() async {
    if (kIsWeb) return null;
    return await _fcm.getToken();
  }

  // === In-App Notification (Firestore) ===

  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

    // ฟังก์ชันสำหรับสร้างการแจ้งเตือนเมื่อมีการจองห้องพักใหม่
  Future<void> createBookingNotification(int userId, int ownerId, String dormName, String roomName) async {
    final batch = _firestore.batch();

    // 1. แจ้งเตือนผู้ใช้ (User)
    final userNotifRef = _firestore.collection('notifications').doc();
    batch.set(userNotifRef, {
      'userId': userId.toString(),
      'type': 'booking_success',
      'title': 'การจองสำเร็จ',
      'desc': 'คุณได้ทำการจองห้อง $roomName ที่ $dormName สำเร็จแล้ว รอการติดต่อจากเจ้าของหอพัก',
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    // 2. แจ้งเตือนเจ้าของหอพัก (Owner)
    final ownerNotifRef = _firestore.collection('notifications').doc();
    batch.set(ownerNotifRef, {
      'userId': ownerId.toString(),
      'type': 'new_booking',
      'title': 'มีการจองใหม่',
      'desc': 'มีผู้เช่าใหม่ทำการจองห้อง $roomName ที่ $dormName ของคุณ',
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

    // ฟังก์ชันสำหรับสร้างการแจ้งเตือนเมื่อเจ้าของหอพักอนุมัติการจอง
  Future<void> createApprovalNotification(int userId) async {
    final userNotifRef = _firestore.collection('notifications').doc();
    await userNotifRef.set({
      'userId': userId.toString(),
      'type': 'booking_approved',
      'title': 'การจองได้รับการอนุมัติ',
      'desc': 'คำขอจองของคุณได้รับการอนุมัติแล้ว กรุณาชำระเงิน',
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  // ฟังก์ชันสำหรับสร้างการแจ้งเตือนเมื่อเจ้าของหอพักตรวจสอบสลีปและกำหนดวันเข้าอยู่
  Future<void> createSlipVerifiedNotification(int userId, String moveInDate) async {
    final userNotifRef = _firestore.collection('notifications').doc();
    await userNotifRef.set({
      'userId': userId.toString(),
      'type': 'slip_verified',
      'title': 'การชำระเงินสำเร็จ',
      'desc': 'ตรวจสอบสลีปเรียบร้อย คุณสามารถย้ายเข้าอยู่ได้ตั้งแต่วันที่ $moveInDate เป็นต้นไป',
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

    // ฟังก์ชันสำหรับสร้างการแจ้งเตือนเมื่อผู้เช่าส่งสลิปชำระเงิน
  Future<void> createPaymentSlipNotification(int ownerId) async {
    final ownerNotifRef = _firestore.collection('notifications').doc();
    await ownerNotifRef.set({
      'userId': ownerId.toString(),
      'type': 'payment_slip',
      'title': 'แจ้งชำระเงิน',
      'desc': 'มีผู้ใช้ส่งหลักฐานการชำระเงินแล้ว',
      'isRead': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<QuerySnapshot> getUserNotifications(int userId) {
    return _firestore
        .collection('notifications')
        .where('userId', isEqualTo: userId.toString())
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

    // ฟังก์ชันสำหรับทำเครื่องหมายว่าอ่านข้อความในแชทแล้ว
  Future<void> markAsRead(String notifId) async {
    await _firestore.collection('notifications').doc(notifId).update({
      'isRead': true,
    });
  }
}

// Global background message handler (must be a top-level function)
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  if (kDebugMode) {
    print("Handling a background message: ${message.messageId}");
  }
}
