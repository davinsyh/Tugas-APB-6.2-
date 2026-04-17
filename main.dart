import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// Inisialisasi plugin notifikasi secara global
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  // Pastikan binding flutter sudah terinisialisasi
  WidgetsFlutterBinding.ensureInitialized();

  // Konfigurasi icon untuk notifikasi dari Android (perlu ada file icon di res/drawable atau gunakan mipmap)
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  // Inisialisasi konfigurasi
  await flutterLocalNotificationsPlugin.initialize(settings: initializationSettings);

  // Meminta izin notifikasi untuk Android 13 (Tiramisu) ke atas
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tugas Local Notification',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const NotificationPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // Fungsi untuk memunculkan notifikasi
  Future<void> _showLocalNotification() async {
    // Mengambil waktu saat ini
    final now = DateTime.now();
    // Memformat string waktu ke HH:MM:SS
    final String jam = now.hour.toString().padLeft(2, '0');
    final String menit = now.minute.toString().padLeft(2, '0');
    final String detik = now.second.toString().padLeft(2, '0');
    final String timeStr = '$jam:$menit:$detik';

    // Konfigurasi spesifik untuk channel Android
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'tugas_notif_channel', // ID Channel
          'Tugas Notifikasi Lokal', // Nama Channel
          channelDescription:
              'Channel ini digunakan untuk tugas notifikasi lokal.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidDetails,
    );

    await flutterLocalNotificationsPlugin.show(
      id: 0,
      title: 'Notifikasi Ditekan',
      body: 'Anda menekan tombol pada waktu $timeStr',
      notificationDetails: platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Notification App')),
      body: const Center(
        child: Text(
          'Tekan tombol lonceng di bawah\nuntuk memunculkan notifikasi!',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 18),
        ),
      ),
      // Floating Action Button
      floatingActionButton: FloatingActionButton(
        onPressed: _showLocalNotification, // Panggil fungsi saat ditekan
        tooltip: 'Munculkan Notifikasi',
        child: const Icon(Icons.notifications_active),
      ),
    );
  }
}
