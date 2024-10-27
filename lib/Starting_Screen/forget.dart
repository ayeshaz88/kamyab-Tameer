import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'login.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

 final TextEditingController _emailController = TextEditingController();

 Future<void> _sendPasswordResetEmail() async {
   try {
     // Attempt to send the password reset email
     await FirebaseAuth.instance.sendPasswordResetEmail(
       email: _emailController.text.trim(),
     );

     // If no exception is thrown, the password reset email has been sent successfully.
     // Show a snackbar to inform the user that the email has been sent.
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Password reset email has been sent.'),
       ),
     );

     // Navigate to the login page
     Navigator.of(context).push(MaterialPageRoute(
       builder: (context) => LoginPage(),
     ));
   } on FirebaseAuthException catch (error) {
     // Handle FirebaseAuthException errors
     print('FirebaseAuthException occurred: $error');
     String errorMessage = 'Error sending password reset email.';
     if (error.code == 'user-not-found') {
       errorMessage = 'Email is not registered.';
     } else {
       errorMessage = 'Error occurred: ${error.message}';
     }
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text(errorMessage),
       ),
     );
   } catch (error) {
     // Handle other errors
     print('Error occurred: $error');
     ScaffoldMessenger.of(context).showSnackBar(
       SnackBar(
         content: Text('Error sending password reset email.'),
       ),
     );
   }
 }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forget Password',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1F2544),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 300,
                height: 300, // Adjust height as needed
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Usability_testing.gif'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                controller: _emailController,
                labelText: 'Email or Phone',
                icon: Icons.phone_android,
                color: const Color(0xFF1F2544),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  _sendPasswordResetEmail();
                  // Implement forget password functionality here
                  print('Forget Password clicked');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2544),
                ),
                child: const Text(
                  'Send Code',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      // Implement login redirection functionality here
                      print('Back to Login clicked');
                      Navigator.pop(context); // Navigate back to the login page
                    },
                    child: const Text(
                      'Back to Login',
                      style: TextStyle(color: Color(0xFF1F2544)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required String labelText,
    required IconData icon,
    required Color color,
    required controller,
  }) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(
          icon,
          color: color,
        ),
        filled: true,
        fillColor: const Color.fromARGB(199, 198, 207, 252),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
    );
  }
}
