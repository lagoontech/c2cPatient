import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../Notification/controller.dart';
import '../../ReusableUtils_/AppColors.dart';
import '../../ReusableUtils_/appBar.dart';
import '../../ReusableUtils_/customLabel.dart';
import '../../ReusableUtils_/image_background.dart';

class NotificationView extends StatelessWidget {
  NotificationView({super.key});

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      appBar: CustomAppBar(
        title: "Notification",
      ),
      child: RefreshIndicator(
        onRefresh: () async {
          await controller.allNotifications();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 4.w),
          child: GetBuilder<NotificationController>(
            builder: (v) {
              return ListView(
                physics: AlwaysScrollableScrollPhysics(),
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                children: [
                  v.listNotification.isNotEmpty
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomLabel(
                                text: "Today",
                                fontSize: 19.0, // Adjust font size as needed
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            CustomLabel(
                              text: "Mark all as read",
                              fontSize: 12.0,
                              color: Colors.black,
                            ),
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: 10.0),
                  if (v.listNotification.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Text(
                          "No notifications available.",
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: v.listNotification.length,
                      itemBuilder: (context, index) {
                        var data = v.listNotification[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 5.0),
                          child: InkWell(
                            onTap: () {
                              showNotificationDetailsDialog(context, data);
                            },
                            child: CustomNotification(
                              icon: Icons.notifications,
                              circleColor: Color(0xfffafcf9),
                              iconColor: Colors.blue,
                              heading: data.data!.title,
                              message: data.data!.body,
                              notificationId:data.id,
                              time: data.createdAt,
                            ),
                          ),
                        );
                      },
                    ),
                  SizedBox(height: 10.0),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class CustomNotification extends StatelessWidget {
  final String? heading;
  final String? message;
  final IconData? icon;
  final Color? circleColor;
  final Color? iconColor;
  final String? notificationId;
  final DateTime? time;

  CustomNotification({
    super.key,
    this.heading,
    this.message,
    this.icon,
    this.circleColor,
    this.iconColor,
    this.notificationId,
    this.time, // Initialize the time property
  });

  final NotificationController controller = Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(notificationId),
      direction: DismissDirection.endToStart,
      background: Container(
        color: AppColors.primaryColor.withOpacity(0.8),
        child: Row(
          children: [
            SizedBox(width: 20),
            Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
      onDismissed: (direction) {
        controller.deleteNotification(notificationId!);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Notification deleted'),
          ),
        );
      },
      secondaryBackground: Container(
        color: AppColors.primaryColor.withOpacity(0.7),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Icon(Icons.delete, color: Colors.red),
            SizedBox(width: 20),
          ],
        ),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.09),
          borderRadius: BorderRadius.circular(7),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: CircleAvatar(
                radius: 35,
                backgroundColor: circleColor ?? Colors.blue,
                child: Icon(
                  icon ?? Icons.notifications,
                  size: 22,
                  color: iconColor ?? Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Heading on the left
                        Expanded(
                          child: Text(
                            heading ?? "Notification",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        // Time on the right
                        if (time != null)
                          Text(
                            "${time!.hour}:${time!.minute.toString().padLeft(2, '0')} ${time!.hour >= 12 ? 'PM' : 'AM'}",
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      message ?? "This is a notification message.",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}





void showNotificationDetailsDialog(BuildContext context, var notificationData) {
  showDialog(
    context: context,
    barrierDismissible: true,  // Allows closing the dialog by tapping outside
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: AnimatedDialogContent(notificationData: notificationData),
      );
    },
  );
}

class AnimatedDialogContent extends StatefulWidget {
  final dynamic notificationData;

  const AnimatedDialogContent({Key? key, required this.notificationData}) : super(key: key);

  @override
  _AnimatedDialogContentState createState() => _AnimatedDialogContentState();
}

class _AnimatedDialogContentState extends State<AnimatedDialogContent> with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<Offset> _offsetAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: Offset(0, 1),  // Start from below the screen
      end: Offset.zero,      // End at the center of the screen
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    // Start the animation
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.notificationData.data!.title!,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                widget.notificationData.data!.body!,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.of(context).pop(), // Close dialog
                child: Text("Close"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
