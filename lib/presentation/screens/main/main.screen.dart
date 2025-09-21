import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:meditation_center/data/services/permission.services.dart';
import 'package:meditation_center/presentation/pages/item%20menus/item.menu.page.dart';
import 'package:meditation_center/presentation/pages/home/home.page.dart';
import 'package:meditation_center/presentation/pages/notice/page/notice.page.dart';
import 'package:meditation_center/presentation/pages/notification/notification.page.dart';
import 'package:meditation_center/presentation/pages/upload/page/upload.page.dart';
import 'package:meditation_center/core/theme/app.colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final cUSer = FirebaseAuth.instance.currentUser!.uid;
  validateUser() {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) {
      context.push('/login');
    }
  }

  @override
  void initState() {
    super.initState();
    // validate User
    validateUser();
    PermissionServices.requestPermissions();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      animationDuration: Duration(milliseconds: 500),
      length: 5,
      child: Builder(
        builder: (BuildContext innerContext) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text(
                  'Mediation Center',
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        color: AppColors.whiteColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    context.push('/profile', extra: cUSer);
                  },
                  icon: Icon(Icons.account_circle),
                  color: AppColors.whiteColor,
                  iconSize: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: IconButton(
                    onPressed: () {
                      context.push('/settings');
                    },
                    icon: Icon(Icons.settings),
                    color: AppColors.whiteColor,
                    iconSize: 30,
                  ),
                ),
              ],
              bottom: const TabBar(
                labelColor: AppColors.whiteColor,
                dividerColor: AppColors.primaryColor,
                automaticIndicatorColorAdjustment: true,
                unselectedLabelColor: AppColors.secondaryColor,
                indicatorColor: AppColors.primaryColor,
                tabs: [
                  Tab(icon: Icon(Icons.home_rounded, size: 25)),
                  Tab(icon: Icon(Icons.newspaper_rounded, size: 25)),
                  Tab(icon: Icon(Icons.add_circle_rounded, size: 25)),
                  Tab(icon: Icon(Icons.calendar_month_rounded, size: 25)),
                  Tab(icon: Icon(Icons.notifications, size: 25)),
                ],
              ),
            ),
            body: TabBarView(
              children: [
                // HomePage
                HomePage(),
                // notice page
                NoticePage(),

                // PostPage
                UploadPage(),

                // BookingPage
                ItemMenuPage(),

                // NotificationPage
                NotificationPage(),
              ],
            ),
          );
        },
      ),
    );
  }
}
