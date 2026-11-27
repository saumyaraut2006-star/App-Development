import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/hive_service.dart';
import 'services/notification_service.dart';
import 'services/fcm_service.dart';
import 'providers/contact_provider.dart';
import 'providers/transaction_provider.dart';
import 'screens/auth_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Firebase (Auth + Firestore + Messaging depend on this)
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Local Hive database (offline storage)
    await HiveService.init();
  } catch (e, s) {
    debugPrint('Startup error: $e\n$s');
    runApp(MaterialApp(
      home: Scaffold(
        body: Center(child: SelectableText('Startup error: $e')),
      ),
    ));
    return;
  }

  // Show the app first
  runApp(const MyApp());

  // Set up notifications after the app is on screen
  initNotifications();
}

Future<void> initNotifications() async {
  try {
    await NotificationService.init();
  } catch (e) {
    debugPrint('Local notification error: $e');
  }

  try {
    await FCMService.init();
  } catch (e) {
    debugPrint('FCM error: $e');
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ContactProvider()),
        ChangeNotifierProvider(create: (_) => TransactionProvider()),
      ],
      child: MaterialApp(
        title: 'SmartInterestX',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A5F)),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}