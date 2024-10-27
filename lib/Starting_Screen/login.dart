import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../Admin/admin.dart';
import '../Client/client.dart';
import '../Contractor/contractor.dart';
import '../Seller/seller.dart';
import '../auth_service.dart';
import 'forget.dart';
import 'register.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _userTypeController = TextEditingController();

  LoginPage({Key? key});

  void _login(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();
    String userType = _userTypeController.text.trim(); // Retrieve selected user type

    if (username.isNotEmpty && password.isNotEmpty && userType.isNotEmpty) {

      if (userType == 'Admin' && username == 'admin' && password == 'admin') {
        // If the user is admin, navigate to admin dashboard
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminDashboard()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Logged in as an admin')),
        );
        return;
      }

      String result = await AuthController().loginUser(username, password, context);



      if (result == '') {
        // If login successful, retrieve user's document from Firestore
        var userSnap = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();
        var userActualType = userSnap.data()!['type']; // Retrieve actual user type from Firestore

        // Check if actual user type matches selected user type
        if (userActualType == userType) {
          // Navigate to the appropriate dashboard based on user type
          switch (userType) {
            case 'Client':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ClientDashboard()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged in as a client')),
              );
              break;
            case 'Contractor':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ContractorDashboard()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged in as a contractor')),
              );
              break;
            case 'Seller':
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SellerDashboard()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Logged in as a seller')),
              );
              break;
            default:
            // Handle unknown user types
              break;
          }
          return;
        } else {
          // Show error message if user type doesn't match
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Error', style: TextStyle(color: Color(0xFF1F2544),)),
                content: const Text('Invalid user type.'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text(
                      'OK',
                      style: TextStyle(color: Colors.black),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              );
            },
          );
        }
      } else {
        // Handle login errors
        // Show appropriate error messages
      }
    } else {
      // Handle empty fields
      // Show appropriate error messages
    }
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss the keyboard when tapping on the background
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Login',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF1F2544),
          iconTheme: const IconThemeData(color: Colors.white),
          shape: const ContinuousRectangleBorder(
              borderRadius: BorderRadius.vertical(
                bottom: Radius.circular(50),
              )
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 400,
                  height: 450, // Adjust height as needed
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage('assets/images/Software_engineer.gif'),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  labelText: 'Email',
                  icon: Icons.email,
                  color: const Color(0xFF1F2544),
                  controller: _usernameController,
                ),
                const SizedBox(height: 16),
                _buildInputField(
                  labelText: 'Password',
                  icon: Icons.lock,
                  color: const Color(0xFF1F2544),
                  obscureText: true,
                  controller: _passwordController,
                ),
                const SizedBox(height: 16),
                _buildDropdownField(
                  labelText: 'User Type',
                  icon: Icons.person_outline,
                  color: const Color(0xFF1F2544),
                  items: ['Client', 'Contractor', 'Seller','Admin'],// yeh abhe modify ke hay menay.
                  controller: _userTypeController,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => _login(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1F2544),
                  ),
                  child: const Text(
                    'Login',
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
                        // Navigate to ForgetPage when Forget Password is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ForgetPassword(),
                          ),
                        );
                      },
                      child: const Text(
                        'Forget Password?',
                        style: TextStyle(color: Color(0xFF1F2544)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    GestureDetector(
                      onTap: () {
                        // Navigate to RegisterPage when Register is clicked
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterPage(),
                          ),
                        );
                      },
                      child: const Text(
                        'Register',
                        style: TextStyle(color: Color(0xFF1F2544)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
    required TextEditingController controller,
  }) {
    return TextField(
      controller: controller,
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

  Widget _buildDropdownField({
    required String labelText,
    required IconData icon,
    required Color color,
    required List<String> items,
    required TextEditingController controller,
  }) {
    return DropdownButtonFormField<String>(
      items: items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item),
        );
      }).toList(),
      onChanged: (String? value) {
        controller.text = value ?? '';
      },
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
