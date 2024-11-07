import 'dart:convert';
import 'package:care2care/sharedPref/sharedPref.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final String backendUrl = 'https://care2carevital.us/api/patients/patient/create-payment-intent';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initialize the Stripe SDK here if needed
  }

  Future<void> _handlePayment() async {
    setState(() => _isLoading = true);

    try {
      // Step 1: Create a PaymentMethod
      final paymentMethod = await Stripe.instance.createPaymentMethod(
        params: PaymentMethodParams.card(
          paymentMethodData: PaymentMethodData(),
        ),
      );

      // Step 2: Call Laravel backend to create a PaymentIntent
      final clientSecret = await _fetchPaymentIntentClientSecret(paymentMethod.id);

      // Step 3: Confirm the payment using the Payment Sheet
    /*  await Stripe.instance.presentPaymentSheet(
        parameters: PresentPaymentSheetParameters(
          clientSecret: clientSecret,
          confirmPayment: true,
        ),
      );*/

      // If the payment is successful
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Successful!')),
      );
    } on StripeException catch (e) {
      print("Stripe error: ${e.error.localizedMessage}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: ${e.error.localizedMessage}')),
      );
    } catch (error) {
      print("General error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Payment Failed: $error')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String> _fetchPaymentIntentClientSecret(String paymentMethodId) async {
    String? token = await SharedPref().getToken();
    if (token == null) {
      throw Exception("User is not authenticated");
    }

    final response = await http.post(
      Uri.parse(backendUrl),
      body: jsonEncode({
        "amount": 100, // Amount in cents
        "currency": "usd",
        "description": "Test payment from Care2Care App",
        "payment_method": paymentMethodId, // Directly attach the payment method
        "shipping": {
          "name": "Sheik ali",
          "address": {"line1": "#9/13E, New Street"}
        },
      }),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse.containsKey('clientSecret')) {
        return jsonResponse['clientSecret'];
      } else {
        throw Exception('Client secret not found in response');
      }
    } else {
      throw Exception('Failed to create PaymentIntent: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Stripe Payment')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CardField(
            onCardChanged: (card) {
              print(card);
            },
          ),
          SizedBox(height: 20),
          _isLoading
              ? CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _handlePayment,
            child: Text('Pay'),
          ),
        ],
      ),
    );
  }
}
