import 'package:care2care/Notification/controller.dart';
import 'package:care2care/Screens_/Notifications/Notification_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';

import '../Screens_/SerachPage/searchPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions; // Accept a list of actions
  final Widget? leading;
  final PreferredSizeWidget? bottom;
  final Color? appbarBackgroundColor;
  final bool ? isbackKey;

  CustomAppBar(
      {Key? key,
      this.title,
      this.actions,
      this.leading,
      this.bottom,
        this.isbackKey,
      this.appbarBackgroundColor})
      : super(key: key);
  NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return AppBar(
      scrolledUnderElevation: 0,
      backgroundColor: appbarBackgroundColor ?? Colors.white,
      leading: leading ??
          IconButton(
              highlightColor: Colors.transparent,
              splashColor: Colors.transparent,
              onPressed: () {
                  Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios,color: Colors.black,)),
      title: Text(
        title ?? '',
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w600),
      ),
      bottom: bottom,
      centerTitle: true,
      actions: actions ?? [const SizedBox()], // Use the list of actions
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(
        kToolbarHeight + (bottom?.preferredSize.height ?? 0.0),
      );
}

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String username;
  final String subtitle;
  final String avatarUrl; // You can also use AssetImage for local images
  final List<Widget>? actions;

  HomeAppBar({
    required this.username,
    required this.subtitle,
    required this.avatarUrl,
    this.actions,
  });

  NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: Size.fromHeight(100.0), // Adjust height as needed
      child: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.white,
        // Adjust to match your design
        elevation: 0,
        // Remove shadow for a flat design
        leading: Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: CircleAvatar(
            radius: 20.0, // Adjust size as needed
            backgroundImage: NetworkImage(
                avatarUrl), // Replace with AssetImage for local images
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hi, $username',
              style: TextStyle(
                color: Colors.black, // Adjust to match your design
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.grey, // Adjust to match your design
                fontSize: 14.0,
              ),
            ),
          ],
        ),
        actions: actions ??
            [
              IconButton(
                icon: Icon(IconlyLight.search, color: Colors.black),
                onPressed: () {
                  Navigator.push(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation, secondaryAnimation) =>
                          SearchPage(),
                      transitionsBuilder:
                          (context, animation, secondaryAnimation, child) {
                        const begin = Offset(0.0, 1.0);
                        const end = Offset.zero;
                        const curve = Curves.easeInOut;
                        var tween = Tween(begin: begin, end: end)
                            .chain(CurveTween(curve: curve));
                        var offsetAnimation = animation.drive(tween);
                        return SlideTransition(
                          position: offsetAnimation,
                          child: child,
                        );
                      },
                    ),
                  );
                },
              ),
              GetBuilder<NotificationController>(builder: (v) {
                return Badge(
                  offset: Offset(-5, 3),
                  label: Text(v.unreadCount.toString()),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: Icon(IconlyLight.notification, color: Colors.black),
                    // Adjust icon color
                    onPressed: () {
                      v.notificationsUnread();
                      Get.to(() => NotificationView());
                    },
                  ),
                );
              }),
              SizedBox(width: 16.w), // Add some space at the end
            ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(60);
}
