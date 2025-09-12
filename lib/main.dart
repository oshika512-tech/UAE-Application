import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/data/firebase/firebase_options.dart';
import 'package:meditation_center/core/routing/app.routing.dart';
import 'package:meditation_center/core/theme/app.theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:meditation_center/data/services/animation.services.dart';
import 'package:meditation_center/providers/notification.provider.dart';
import 'package:meditation_center/providers/post.with.user.data.provider.dart';
import 'package:meditation_center/providers/post.provider.dart';
import 'package:meditation_center/providers/user.provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // initialize Notification
  await LocalNotification().initialize();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => PostProvider()),
          ChangeNotifierProvider(create: (_) => PostWithUserDataProvider()),
          ChangeNotifierProvider(create: (_) => PostWithUserDataProvider()),
           ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int durationVal = 1;
  Future<int> getDuration() async {
    final val = await AnimationServices().getAnimationDuration();
    setState(() {
      durationVal = val;
    });
    return val;
  }

  @override
  void initState() {
    super.initState();
    getDuration();
    LocalNotification().requestPermission();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mediation Center',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouting(duration: durationVal).appRouter,
      builder: EasyLoading.init(),
    );
  }
}
