import 'dart:async';
import 'package:flutter/material.dart';
import 'package:kamiyabtameer/Contractor/contractor.dart';
import 'package:kamiyabtameer/Seller/seller.dart';

import '../Admin/admin.dart';
import '../Client/client.dart';


class OTPScreen extends StatefulWidget {
  final String userType;

  const OTPScreen({Key? key, required this.userType}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final TextEditingController _otpController1 = TextEditingController();
  final TextEditingController _otpController2 = TextEditingController();
  final TextEditingController _otpController3 = TextEditingController();
  final TextEditingController _otpController4 = TextEditingController();
  final TextEditingController _otpController5 = TextEditingController();
  final TextEditingController _otpController6 = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  int _counter = 60; // Timer counter in seconds
  bool _resendButtonEnabled = false;
  // ignore: unused_field
  late Timer _timer;

  @override
  void initState() {
    super.initState();
  }

  void _startTimer() {
    const oneSecond = Duration(seconds: 1);
    _timer = Timer.periodic(oneSecond, (timer) {
      if (mounted) {
        if (_counter > 0) {
          setState(() {
            _counter--;
          });
        } else {
          setState(() {
            _resendButtonEnabled = true;
          });
          timer.cancel();
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _resendOTP() {
    if (_phoneNumberController.text.isEmpty) {
      _showErrorSnackbar('Please add phone number.');
    } else {
      // Logic to resend OTP, for example, send a new OTP to the user's phone
      setState(() {
        _counter = 60;
        _resendButtonEnabled = false;
        _otpController1.clear();
        _otpController2.clear();
        _otpController3.clear();
        _otpController4.clear();
        _otpController5.clear();
        _otpController6.clear();
        _startTimer();
      });
      _showOTPSentSnackbar();
    }
  }

  void _verifyOTP() {
    // Logic to verify the entered OTP
    String enteredOTP = _otpController1.text +
        _otpController2.text +
        _otpController3.text +
        _otpController4.text +
        _otpController5.text +
        _otpController6.text;

    // Assuming the correct OTP is '123456'
    if (enteredOTP == '111111') {
      // Navigate to the user-specific screen based on userType
      switch (widget.userType.toLowerCase()) {
        case 'client':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ClientDashboard()),
          );
          break;
        case 'contractor':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ContractorDashboard()),
          );
          break;
        case 'seller':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SellerDashboard()),
          );
          break;
          case 'admin':
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => AdminDashboard()),
          );
        default:
          print('Invalid user type');
      }
    } else {
      // Show error message for incorrect OTP
      _showErrorDialog('Incorrect OTP. Please try again.');
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  void _showOTPSentSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text(
          'OTP sent to your phone number',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.lightGreen,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('OTP Verification', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/otp.gif',
                width: 350,
                height: 350,
                fit: BoxFit.contain,
              ),
              TextField(
                controller: _phoneNumberController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Enter Phone Number',
                  prefixIcon: const Icon(Icons.phone, color: Color(0xFF1F2544)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_phoneNumberController.text.isEmpty) {
                    _showErrorSnackbar('Please add phone number.');
                  } else {
                    _showOTPSentSnackbar();
                    _startTimer();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF1F2544),
                ),
                child: const Text('Send OTP'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildOTPDigitInput(_otpController1),
                  _buildOTPDigitInput(_otpController2),
                  _buildOTPDigitInput(_otpController3),
                  _buildOTPDigitInput(_otpController4),
                  _buildOTPDigitInput(_otpController5),
                  _buildOTPDigitInput(_otpController6),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _verifyOTP,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: const Color(0xFF1F2544),
                ),
                child: const Text('Verify'),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Resend OTP in $_counter seconds'),
                  const SizedBox(width: 8),
                  _resendButtonEnabled
                      ? ElevatedButton(
                          onPressed: _resendOTP,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white, backgroundColor: const Color(0xFF1F2544),
                          ),
                          child: const Text('Resend OTP'),
                        )
                      : const SizedBox.shrink(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOTPDigitInput(TextEditingController controller) {
    return SizedBox(
      width: 40,
      height: 40,
      child: TextField(
        controller: controller,
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        onChanged: (value) {
          // Automatically move to the next input field
          if (value.isNotEmpty) {
            FocusScope.of(context).nextFocus();
          }
        },
        decoration: InputDecoration(
          counter: const Offstage(),
          contentPadding: EdgeInsets.zero,
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF1F2544), width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Color(0xFF1F2544), width: 2.0),
            borderRadius: BorderRadius.circular(5.0),
          ),
        ),
      ),
    );
  }
}
