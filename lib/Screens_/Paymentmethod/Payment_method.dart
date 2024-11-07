import 'package:care2care/ReusableUtils_/customButton.dart';
import 'package:care2care/ReusableUtils_/customLabel.dart';
import 'package:care2care/ReusableUtils_/image_background.dart';
import 'package:care2care/ReusableUtils_/sizes.dart';
import 'package:care2care/Screens_/Paymentmethod/controller/paymentMethod_controller.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../ReusableUtils_/appBar.dart';
import '../SuccessfulPament/paymet_successfulView.dart';

class PaymentMethod extends StatelessWidget {
  PaymentMethod({super.key});

  PayMethodController pay = Get.put(PayMethodController());

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
      bottomNavBar: Container(
        height: MediaQuery.of(context).size.height * 0.10,
        color: Colors.white,
        child: Center(
          child: CustomButton(
            text: "Add CheckOut",
            onPressed: () {
              Get.to(()=> PaymentSuccessful());
            },
            fontSize: 18.sp,
            textColor: Colors.white,
          ),
        ),
      ),
      appBar: CustomAppBar(
        title: "Payment Method",
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomLabel(text: "Your Address"),
              kHeight10,
              Container(
                height: MediaQuery.of(context).size.height * 0.15,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Shadow color
                      spreadRadius: 1, // Spread radius
                      blurRadius: 8, // Blur radius
                      offset: Offset(0, 9), // Offset for shadow (bottom shadow)
                    ),
                  ],
                  borderRadius: BorderRadius.circular(12.r),
                  color: CupertinoColors.white,
                ),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(8.r),
                          child: Container(
                            padding: EdgeInsets.all(4.r),
                            height: MediaQuery.of(context).size.height * 0.12,
                            width: MediaQuery.of(context).size.width * 0.28,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30.r),
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Image.asset(
                                    "assets/images/Map (1).png",
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Center(
                                  child: Icon(
                                    Icons.location_on,
                                    size: 30.sp,
                                    color: Colors.black.withOpacity(0.8),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        kWidth10,
                        Flexible(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              kHeight10,
                              Text(
                                "Home",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                "1234 Elm Street",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "Springfield, IL 62704",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                              Text(
                                "USA",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Icon at the top-right corner
                    Positioned(
                      top: 8.r,
                      right: 8.r,
                      child: Container(
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                            border: Border.all(width: 0.2, color: Colors.black),
                            shape: BoxShape.circle),
                        child: Icon(
                          EneftyIcons.link_4_outline,
                          size: 12.sp,
                          color: Colors.black.withOpacity(0.8),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              kHeight15,
              CustomLabel(
                text: "Add Payment Method",
                fontSize: 17.sp,
              ),
              kHeight10,
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  PaymentTypeWidget(
                    image: "assets/images/payment/gpay.png",
                    index: 0,
                  ),
                  PaymentTypeWidget(
                    image: "assets/images/payment/phonpe.png",
                    index: 1,
                  ),
                  PaymentTypeWidget(
                    image: "assets/images/payment/visa.png",
                    index: 2,
                  ),
                  PaymentTypeWidget(
                    image: "assets/images/payment/paypal.png",
                    index: 3,
                  ),
                ],
              ),
              kHeight15,
              CustomLabel(
                text: "Add Payment Method",
                fontSize: 17.sp,
              ),
              kHeight15,
              CustomLabel(text: "Name"),
              kHeight10,
              CustomTextField(),
              kHeight10,
              CustomLabel(text: "Card Number "),
              kHeight10,
              CustomTextField(
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                  CardNumberFormatter(),
                ],
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.network(
                    'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2a/Mastercard-logo.svg/800px-Mastercard-logo.svg.png',
                    height: 30,
                    width: 30,
                  ),
                ),
              ),
              kHeight10,
              Container(
                height: MediaQuery.of(context).size.height * 0.13,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                        child: Column(
                      children: [
                        CustomLabel(text: "cvv"),
                        kHeight10,
                        CustomTextField(
                          keyboardType: TextInputType.number,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(3),
                          ],
                        ),
                      ],
                    )),
                    kWidth15,
                    Expanded(
                        child: Column(
                      children: [
                        CustomLabel(text: "Expires"),
                        kHeight10,
                        CustomTextField(),
                      ],
                    )),
                  ],
                ),
              ),
              kHeight10,
              GetBuilder<PayMethodController>(
                builder: (context) {
                  return CheckboxListTile(
                    title: Text(
                      "Save this Address for Next time" ,
                      style: TextStyle(color: pay.checkedValue ? Colors.red : null),
                    ),
                    value: pay.checkedValue,
                    onChanged: (newValue) {
                      pay.checkedValue = newValue!;
                      pay.update();
                    },
                    controlAffinity: ListTileControlAffinity.leading,
                    dense: true,
                    activeColor: Colors.red,
                  );
                }
              )
            ],
          ),
        ),
      ),
    );
  }
}

class PaymentTypeWidget extends StatelessWidget {
  final String image;
  final int index;

  const PaymentTypeWidget({
    required this.image,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PayMethodController>(
      builder: (controller) {
        final bool isSelected = controller.selectedPaymentIndex == index;
        return InkWell(
          onTap: () {
            controller.selectedPaymentIndex = index;
            controller.update();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.r),
            height: 35.h,
            width: 66.w,
            decoration: BoxDecoration(
              border: Border.all(
                width: 1.5,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
            ),
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String? labelText;
  final String hintText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final Function(String)? onChanged;
  List<TextInputFormatter>? inputFormatter;
  Widget? suffixIcon;
  Color? fillColor;

  CustomTextField(
      {Key? key,
      this.labelText,
      this.hintText = '',
      this.controller,
      this.keyboardType = TextInputType.text,
      this.obscureText = false,
      this.onChanged,
      this.fillColor,
      this.suffixIcon,
      this.inputFormatter})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      inputFormatters: inputFormatter,
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: fillColor ?? Colors.grey.withOpacity(0.2),
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(45.r),
        ),
      ),
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
    );
  }
}

class CardNumberFormatter extends TextInputFormatter {
  static const int maxLength = 16;

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue previousValue,
    TextEditingValue nextValue,
  ) {
    final inputText = nextValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (inputText.length > maxLength) {
      return previousValue;
    }

    final bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      if (i > 0 && (i + 1) % 4 == 0 && (i + 1) != inputText.length) {
        bufferString.write(' ');
      }
    }

    final string = bufferString.toString();
    return nextValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(
        offset: string.length,
      ),
    );
  }
}
