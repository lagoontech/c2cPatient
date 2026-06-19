import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:care2care/Utils/screen_utils.dart';

class AppointmentsContainer extends StatelessWidget {
  final String imageUrl;
  final Color? statusColor;
  final List<DateTime>? appointmentDates;
  final String appointmentTime;
  final String doctorName;
  final String doctorDesignation;
  final String? action;
  final Color? actionColor;
  final IconData? actionIcon;
  final VoidCallback? actionTap;

  const AppointmentsContainer({
    super.key,
    required this.imageUrl,
    this.statusColor,
    this.appointmentDates,
    required this.appointmentTime,
    required this.doctorName,
    required this.doctorDesignation,
    this.action,
    this.actionTap,
    this.actionColor,
    this.actionIcon,
  });

  @override
  Widget build(BuildContext context) {
    final bool isiPad = isiPadLayout(context);
    final double containerHeight = isiPad ? 185.h : 160.h;

    return Container(
      height: containerHeight,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300, width: 0.6),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(1, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left colored strip
          Container(
            width: 6.w,
            height: double.infinity,
            decoration: BoxDecoration(
              color: statusColor ?? AppColors.primaryColor,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                bottomLeft: Radius.circular(12.r),
              ),
            ),
          ),

          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Appointment Details",
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.more_vert_outlined),
                        onPressed: () {},
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),

                  SizedBox(height: 6.h),

                  // Date and time row
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16.sp,
                        color: AppColors.primaryColor,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        _buildDateRange(),
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Text(
                        '•',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.black45,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Flexible(
                        child: Text(
                          appointmentTime,
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.h),
                  Divider(color: Colors.grey.shade300, height: 1.h),
                  SizedBox(height: 10.h),

                  // Doctor info and action row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 25.r,
                        backgroundImage: imageUrl.startsWith('http') ? NetworkImage(imageUrl) : null,
                        child: !imageUrl.startsWith('http') ? Icon(Icons.person, size: 25.r) : null,
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              doctorName,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              doctorDesignation,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black54,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      if (action != null) ...[
                        const Spacer(),
                        InkWell(
                          onTap: actionTap,
                          child: Row(
                            children: [
                              if (actionIcon != null)
                                Icon(actionIcon,
                                    size: 18.sp,
                                    color:
                                    actionColor ?? AppColors.secondaryColor),
                              if (actionIcon != null) SizedBox(width: 5.w),
                              Text(
                                action!,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.w500,
                                  color: actionColor ?? AppColors.secondaryColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _buildDateRange() {
    if (appointmentDates == null || appointmentDates!.isEmpty) return '';
    if (appointmentDates!.length == 1) {
      return DateFormat("MMM dd").format(appointmentDates!.first);
    } else {
      return "${DateFormat("MMM dd").format(appointmentDates!.first)} → ${DateFormat("MMM dd").format(appointmentDates!.last)}";
    }
  }
}
