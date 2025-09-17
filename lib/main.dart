import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meditation_center/core/notifications/local.notification.dart';
import 'package:meditation_center/data/firebase/firebase_options.dart';
import 'package:meditation_center/core/routing/app.routing.dart';
import 'package:meditation_center/core/theme/app.theme.dart';
import 'package:device_preview/device_preview.dart';
import 'package:meditation_center/data/services/animation.services.dart';
import 'package:meditation_center/presentation/screens/auth/services/auth.services.dart';
import 'package:meditation_center/providers/comment.provider.dart';
import 'package:meditation_center/providers/notice.provider.dart';
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

  // Initializing notification
  await LocalNotification().initialize();

  // Get verification status and animation duration before running the app
  final bool isUserVerified = await AuthServices.isEmailVerified();
  final int animationDuration = await AnimationServices().getAnimationDuration();

  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => UserProvider()),
          ChangeNotifierProvider(create: (_) => PostProvider()),
          ChangeNotifierProvider(create: (_) => PostWithUserDataProvider()),
          ChangeNotifierProvider(create: (_) => NotificationProvider()),
          ChangeNotifierProvider(create: (_) => CommentProvider()),
          ChangeNotifierProvider(create: (_) => NoticeProvider()),
        ],
        child: MyApp(
          isUserVerified: isUserVerified,
          animationDuration: animationDuration,
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isUserVerified;
  final int animationDuration;
  const MyApp({
    super.key,
    required this.isUserVerified,
    required this.animationDuration,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mediation Center',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouting(
        duration: animationDuration,
        isVerify: isUserVerified,
      ).appRouter,
      builder: EasyLoading.init(),
    );
  }
}