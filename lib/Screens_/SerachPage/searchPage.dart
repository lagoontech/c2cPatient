import 'package:care2care/ReusableUtils_/AppColors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchPage extends StatelessWidget {
  final ScrollController? scrollController;

  SearchPage({this.scrollController});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 7.w),
                  hintText: 'Type something to search...',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: AppColors.primaryColor))),
            ),
            // Add more content related to search as needed
          ],
        ),
      ),
    );
  }
}
