import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:kamiyabtameer/auth_service.dart';
import 'package:kamiyabtameer/widgets/snackbar.dart';

class RegisterPage extends StatefulWidget {

  RegisterPage({Key? key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _selectedUserType = 'Client';

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final TextEditingController _confirmPasswordController =
  TextEditingController();


  void _register(BuildContext context) async {
    String username = _usernameController.text.trim();
    String email = _email.text.trim();
    String password = _passwordController.text.trim();
    String confirmPassword = _confirmPasswordController.text.trim();

    if (username.isNotEmpty && password.isNotEmpty && password == confirmPassword) {
      // Check if the email is already registered for a different user type
      String? existingUserType = await AuthController.getUserTypeByEmail(email);

      if (existingUserType != null) {
        // Email is already registered with a different user type
        String userTypeText = existingUserType == 'Client'
            ? 'client'
            : existingUserType == 'Contractor'
            ? 'contractor'
            : 'seller';
        showCustomSnackBar(
            EvaIcons.alertCircle,
            'Email Already Registered',
            'This email is already registered as a $userTypeText.',
          Color(0xFF1F2544),
        );
      } else {
        String userTypeText = _selectedUserType.toLowerCase();
        String result = await AuthController().Signup(
            username,
            email,
            password,
            _selectedUserType,
            context
        );

        if (result == 'password-error') {
          showCustomSnackBar(
              EvaIcons.alertCircle,
              'Fields Error',
              'Password should be at least 6 characters!',
            Color(0xFF1F2544),
          );
        } else if (result == 'email-error') {
          // This scenario should not occur as we've checked the email earlier
          // But if needed, handle it accordingly
        } else if (result == 'fields-error') {
          showCustomSnackBar(
              EvaIcons.alertCircle,
              'Fields Error',
              'Fields are empty',
            Color(0xFF1F2544),
          );
        } else if (result == 'invalid-email') {
          showCustomSnackBar(
              EvaIcons.alertCircle,
              'Fields Error',
              'Your email is badly formatted!',
            Color(0xFF1F2544),
          );
        } else {
          // Registration successful
          showCustomSnackBar(
              EvaIcons.checkmarkCircle2,
              'Registration Successful',
              'Registered as $userTypeText successfully!',
            Color(0xFF1F2544),
          );
        }
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Registration Failed',
              style: TextStyle(color: Color(0xFF1F2544),),
            ),
            content: const Text('Please fill in all fields correctly.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
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
                decoration:const  BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage('assets/images/Key.gif'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                labelText: 'Username',
                icon: Icons.person,
                color: const Color(0xFF1F2544),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                labelText: 'Email',
                icon: Icons.email,
                color: const Color(0xFF1F2544),
              ),
              const SizedBox(height: 16),
              _buildInputField(
                labelText: 'Password',
                icon: Icons.lock,
                color: const Color(0xFF1F2544),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildInputField(
                labelText: 'Confirm Password',
                icon: Icons.lock,
                color: const Color(0xFF1F2544),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              _buildUserTypeDropdown(),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () => _register(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1F2544),
                ),
                child: const Text(
                  'Register',
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
                    child: const  Text(
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
    bool obscureText = false,
  }) {
    return TextField(
      controller: labelText == 'Username'
          ? _usernameController
          : labelText == 'Email'
          ? _email
          : labelText == 'Password'
          ? _passwordController
          : _confirmPasswordController,
      obscureText: obscureText,
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

  Widget _buildUserTypeDropdown() {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: 'User Type',
        prefixIcon: const Icon(
          Icons.person_outline,
          color: Color(0xFF1F2544),
        ),
        filled: true,
        fillColor: const Color.fromARGB(199, 198, 207, 252),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(40.0),
        ),
      ),
      value: _selectedUserType,
      items: ['Client', 'Contractor', 'Seller'].map((String userType) {
        return DropdownMenuItem<String>(
          value: userType,
          child: Text(userType),
        );
      }).toList(),
      onChanged: (String? value) {
        {
          _selectedUserType = value ?? 'Client';
        };
      },
    );
  }
}
