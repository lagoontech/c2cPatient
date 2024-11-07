import 'package:easy_date_timeline/easy_date_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'AppColors.dart';

class CustomEasyDateTimeLine extends StatelessWidget {
  final DateTime? initialDate;
  final Function(DateTime)? onDateChange;
  List<DateTime>? disabledDates = [];

  CustomEasyDateTimeLine({
    Key? key,
    this.initialDate,
    this.onDateChange,
    this.disabledDates,
  }) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return EasyDateTimeLine(
      initialDate: initialDate ?? DateTime.now(),
      onDateChange: (selectedDate) {
        if (!selectedDate.isBefore(DateTime.now())) {
          if (onDateChange != null) {
            onDateChange!(selectedDate);
          }
        }
      },
      activeColor: AppColors.primaryColor,
      headerProps: EasyHeaderProps(
          showHeader: true,
          showMonthPicker: true,
          monthPickerType: MonthPickerType.dropDown),
      disabledDates: disabledDates,
      dayProps: EasyDayProps(
        height: 65.h,
        width: 45.w,
        activeDayStyle: DayStyle(
          borderRadius: 33.0,
        ),
        inactiveDayStyle: DayStyle(
          borderRadius: 32.0,
        ),
      ),
      timeLineProps: const EasyTimeLineProps(
        hPadding: 10.0,
        separatorPadding: 16.0,
      ),
    );
  }
}
