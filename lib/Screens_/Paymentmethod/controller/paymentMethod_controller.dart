import 'dart:convert';
import 'package:care2care/ReusableUtils_/toast2.dart';
import 'package:care2care/Screens_/Profile/Controller/initila_profile_controller.dart';
import 'package:care2care/constants/api_urls.dart';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../../SuccessfulPament/paymet_successfulView.dart';

class PayMethodController extends GetxController {
  int selectedPaymentIndex = -1;

  bool checkedValue = false;
  bool paymentLoading = false;
  bool stripeLoad = false;
  InitialProfileDetails controller = Get.put(InitialProfileDetails());

  paymentApi({int? appointmentId, int? caretakerId, int? totalAmount}) async {
    paymentLoading = false;
    update();
    try {
      String? token = await SharedPref().getToken();
      var res = await http.post(Uri.parse(ApiUrls().paymentApi), body: {
        "appointment_id": appointmentId.toString(),
        "caretaker_id": caretakerId.toString(),
        'amount_paid': totalAmount.toString()
      }, headers: {
        'Authorization': 'Bearer $token',
      });

      if (res.statusCode == 200) {}
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic>? intentPaymentData;

  makeIntentForPayment(
    amountToBeCharge,
    currency, {
    int? appointmentId,
    int? caretakerId,
  }) async {
    String? token = await SharedPref().getToken();
    try {
      Map<String, dynamic>? paymentInfo = {
        "appointment_id": appointmentId.toString(),
        "caretaker_id": caretakerId.toString(),
        "amount": amountToBeCharge,
        "currency": currency,
        "shipping": {
          "name":
              controller.profileList!.data!.patientInfo!.firstName.toString(),
          "address": {
            "line1":
                controller.profileList!.data!.patientInfo!.address.toString(),
            "postal_code": "10001",
            "city": "Anytown",
            "state": "CA",
            "country": "US",
          }
        }
      };

      var resFromStripeApi = await http.post(
          Uri.parse(/*"https://api.stripe.com/v1/payment_intents"*/
              ApiUrls().paymentGateWay),
          body: jsonEncode(paymentInfo),
          headers: {
            "Authorization": "Bearer $token",
            'Content-Type': 'application/json',
          });
      print("response from API = " + resFromStripeApi.body);
      if (resFromStripeApi.statusCode == 200) {
        var responseJson = jsonDecode(resFromStripeApi.body);
        if (responseJson['success']) {
          intentPaymentData = responseJson['data'];
          var paymentID = responseJson['data']['id'];
          await SharedPref().savePaymentId(paymentID);
          print("-----paymentId${paymentID}");
          print("Payment Intent created successfully: ${intentPaymentData}");
          return intentPaymentData;
        } else {
          print("Failed to create payment intent: ${responseJson['message']}");
        }
      } else {
        print("Error: ${resFromStripeApi.body}");
      }
    } catch (errorMsg, e) {
      print(e);
      print(errorMsg.toString());
    }
  }

  paymentSheetInitialization(
    BuildContext context,
    amountToBeCharge,
    currency, {
    int? appointmentId,
    int? caretakerId,
    String? careTakerName,
    String? bookingDate,
    String? bookingFromTime,
    String? bookingToTime,
    String? paymentsId,
  }) async {
    paymentLoading = true;
    update();
    try {
      // Await the result of makeIntentForPayment
      intentPaymentData = await makeIntentForPayment(amountToBeCharge, currency,
          appointmentId: appointmentId, caretakerId: caretakerId);

      if (intentPaymentData == null ||
          !intentPaymentData!.containsKey("client_secret")) {
        print("Error: Payment intent data is null or missing client_secret.");
        return;
      }

      // Initialize payment sheet with the retrieved client secret
      await Stripe.instance
          .initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          allowsDelayedPaymentMethods: true,
          paymentIntentClientSecret: intentPaymentData!["client_secret"],
          style: ThemeMode.light,
          merchantDisplayName: "Care to Care",
        ),
      )
          .then((_) {
        print("Payment sheet initialized successfully");
      });

      // Show the payment sheet
      showPaymentSheet(context, careTakerName, bookingDate, bookingFromTime,
          bookingToTime, paymentsId,appointmentId,caretakerId,amountToBeCharge);
    } catch (error) {
      print("Error in paymentSheetInitialization: $error");
    }
    paymentLoading = false;
    update();
  }

  showPaymentSheet(
    BuildContext context,
    String? careTakerName,
    String? bookingDate,
    String? bookingFromTime,
    String? bookingToTime,
    String? paymentsId,
    appointmentId,
    caretakerId,
      amount
  ) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((_) async {
        var intentId = await SharedPref().getPaymentId();
        print("Payment completed successfully");
        confirmPayment(

            appointmentId: appointmentId.toString(),
            caretakerId: caretakerId.toString(),
            paymentIntentId: intentId.toString());
        Get.to(() => PaymentSuccessful(
              payId: intentId.toString(),
              careTakerName: careTakerName,
              bookingDate: bookingDate,
              bookingFromTime: bookingFromTime,
              bookingToTime: bookingToTime,
          amount:amount ,
            ));
      }).onError((errorMSG, sTrace) {
        print(
            "Error presenting payment sheet: ${errorMSG.toString()}, StackTrace: ${sTrace.toString()}");
        showCustomToast(message: "Payment Cancelled");
      });
    } on StripeException catch (errorMsg) {
      print("Stripe Exception: $errorMsg");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text("Payment cancelled or failed: ${errorMsg.error}"),
        ),
      );
    } catch (error) {
      print("Unknown error presenting payment sheet: $error");
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          content: Text("An unexpected error occurred: $error"),
        ),
      );
    }
  }

  Future<void> confirmPayment({
    required String appointmentId,
    required String caretakerId,
    required String paymentIntentId,
  }) async {
    try {
      String? token = await SharedPref().getToken();

      // Define the payload
      Map<String, dynamic> payload = {
        "appointment_id": appointmentId,
        "caretaker_id": caretakerId,
        "payment_intent_id": paymentIntentId
      };

      // Make the POST request
      var response = await http.post(
        Uri.parse(ApiUrls().confirmPayment),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      // Check the response status
      if (response.statusCode == 200) {
        var responseData = jsonDecode(response.body);
      } else {
        print("Server error: ${response.body}");
      }
    } catch (e) {
      print("Error in confirmPayment: $e");
    }
  }
}
