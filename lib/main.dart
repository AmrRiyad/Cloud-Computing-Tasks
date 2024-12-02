import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cc_sa_1/screens/base.dart';
import 'package:cc_sa_1/screens/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'screens/base_screen.dart';
import 'shared/firebase_options.dart';

void foregroundNotificationHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    DatabaseReference messagesRef = FirebaseDatabase.instance.ref("messages");

    await messagesRef.push().set({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'date': message.sentTime.toString(),
    });
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

@pragma('vm:entry-point')
Future<void> backgroundNotificationHandler(RemoteMessage message) async {
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    DatabaseReference notificationsRef =
        FirebaseDatabase.instance.ref("notifications");

    await notificationsRef.push().set({
      'title': message.notification?.title,
      'body': message.notification?.body,
      'date': message.sentTime.toString(),
    });
  } catch (e) {
    if (kDebugMode) {
      print(e.toString());
    }
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging messaging = FirebaseMessaging.instance;

  try {
    String? token = await messaging.getToken();
    if (kDebugMode) {
      print("FCM Token: $token");
    }
  } catch (e) {
    if (kDebugMode) {
      print("Error: $e");
    }
  }

  FirebaseMessaging.onMessage.listen(foregroundNotificationHandler);

  FirebaseMessaging.onBackgroundMessage(backgroundNotificationHandler);

  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MyApp(savedThemeMode: savedThemeMode));
}

class MyApp extends StatefulWidget {
  final AdaptiveThemeMode? savedThemeMode;

  const MyApp({super.key, this.savedThemeMode});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends BaseScreen<MyApp> {
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? buildLoadingIndicator()
        : AdaptiveTheme(
            light: ThemeData(
              useMaterial3: true,
              appBarTheme: const AppBarTheme(
                elevation: 4,
                shadowColor: Colors.cyan,
                color: Colors.white,
                foregroundColor: Colors.black,
                titleTextStyle: TextStyle(color: Colors.black),
                actionsIconTheme: IconThemeData(color: Colors.black),
              ),
              dividerTheme: const DividerThemeData(color: Colors.black26),
              scaffoldBackgroundColor: Colors.white,
              bottomNavigationBarTheme: const BottomNavigationBarThemeData(
                elevation: 5,
                backgroundColor: Colors.white,
                selectedItemColor: Colors.cyan,
                unselectedItemColor: Colors.black54,
              ),
              iconTheme: IconThemeData(color: Colors.yellow.shade800),
              textTheme: Typography.blackMountainView.copyWith(
                displayLarge:
                    Typography.blackMountainView.displayLarge?.copyWith(
                  color: Colors.black,
                ),
              ),
              primaryTextTheme: Typography.blackMountainView.copyWith(
                displayLarge:
                    Typography.blackMountainView.displayLarge?.copyWith(
                  color: Colors.black,
                ),
              ),
            ),
            initial: AdaptiveThemeMode.light,
            builder: (theme, darkTheme) => MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              home: currentUser?.uID != "GUEST"
                  ? const MainScreen()
                  : const LoginScreen(),
            ),
          );
  }
}
