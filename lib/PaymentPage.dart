import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PaymentPage extends StatefulWidget {
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _cardNumberController = TextEditingController();
  TextEditingController _expiryDateController = TextEditingController();
  TextEditingController _cvvController = TextEditingController();
  TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  String? _cardNumberValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter card number';
    }
    RegExp regExp = RegExp(r'^[0-9]{16}$');
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid card number';
    }
    return null;
  }

  String? _expiryDateValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter expiry date';
    }
    RegExp regExp = RegExp(r'^\d{2}-\d{4}$');
    if (!regExp.hasMatch(value)) {
      return 'Date format should be MM/YYYY';
    }
    // You can add more validation for month and year if needed
    return null;
  }

  String? _cvvValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter CVV';
    }
    if (value.length != 3 && value.length != 4) {
      return 'CVV should be 3 or 4 digits';
    }
    return null;
  }

  String? _amountValidator(String? value) {
    if (value!.isEmpty) {
      return 'Please enter amount';
    }
    RegExp regExp = RegExp(r'^\d+(\.\d+)?$');
    if (!regExp.hasMatch(value)) {
      return 'Please enter a valid amount';
    }
    return null;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      // Save payment information to Firestore
      FirebaseFirestore.instance.collection('payment').add({
        'cardNumber': _cardNumberController.text,
        'expiryDate': _expiryDateController.text,
        'cvv': _cvvController.text,
        'amount': _amountController.text,
        'timestamp': Timestamp.now(), // Add timestamp for sorting or tracking
      }).then((_) {
        // Show payment success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment successful!'),
            duration: Duration(seconds: 2),
          ),
        );
      }).catchError((error) {
        // Show error message if payment fails
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to process payment: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _cardNumberController,
                decoration: InputDecoration(labelText: 'Card Number'),
                validator: _cardNumberValidator,
              ),
              TextFormField(
                controller: _expiryDateController,
                decoration: InputDecoration(labelText: 'Expiry Date'),
                validator: _expiryDateValidator,
              ),
              TextFormField(
                controller: _cvvController,
                decoration: InputDecoration(labelText: 'CVV'),
                validator: _cvvValidator,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Amount'),
                validator: _amountValidator,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Pay Now'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
