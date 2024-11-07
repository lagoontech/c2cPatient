import 'package:flutter/material.dart';
import 'package:flutter_hot_toast/flutter_hot_toast.dart';

class CustomLoader {
  static void showLoadingOverlay(BuildContext context, {String label = 'loading...', double height = 70, double width = 280}) {
    context.loaderOverlay.show(
      widget: _loadingWidget(label: label, height: height, width: width),
    );
  }

  static void hideLoadingOverlay(BuildContext context) {
    context.loaderOverlay.hide();
  }



  // Reusable loading widget
  static Widget _loadingWidget({required String label, double height = 70, double width = 280}) {
    return Center(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
