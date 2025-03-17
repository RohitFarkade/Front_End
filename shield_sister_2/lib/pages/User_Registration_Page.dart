import 'package:flutter/material.dart';
import '/backend/Authentication.dart';

class UserRegistrationPage extends StatefulWidget {
  const UserRegistrationPage({Key? key}) : super(key: key);

  @override
  _UserRegistrationPageState createState() => _UserRegistrationPageState();
}

class _UserRegistrationPageState extends State<UserRegistrationPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController fullnameController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  String? selectedGender; // Variable to store gender selection

  void register() async {
    final fullname = fullnameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final number = numberController.text.trim();
    final age = ageController.text.trim();

    if (fullname.isEmpty || email.isEmpty || password.isEmpty || number.isEmpty || age.isEmpty || selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All fields are required', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final result = await authService.register(fullname, email, password);

    if (result['message'] == 'User registered successfully') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registration Successful', style: TextStyle(color: Colors.white)),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pushReplacementNamed(context, '/log');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['message'] ?? 'Registration failed', style: const TextStyle(color: Colors.white)),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth * 0.1; // Responsive padding

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/log')
        ),
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
      ),
      backgroundColor: const Color(0xFFDFF3EA),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: paddingValue, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Full Name
                _buildTextField(fullnameController, "Full Name", false),
                const SizedBox(height: 15),

                // Email
                _buildTextField(emailController, "Email", false),
                const SizedBox(height: 15),

                // Number
                _buildTextField(numberController, "Phone Number", false, keyboardType: TextInputType.phone),
                const SizedBox(height: 15),

                // Age
                _buildTextField(ageController, "Age", false, keyboardType: TextInputType.number),
                const SizedBox(height: 15),

                // Gender Dropdown
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2),
                  ),
                  child: DropdownButtonFormField<String>(
                    value: selectedGender,
                    hint: const Text("Select Gender"),
                    decoration: const InputDecoration(border: InputBorder.none),
                    items: ["Male", "Female", "Other"].map((String gender) {
                      return DropdownMenuItem<String>(
                        value: gender,
                        child: Text(gender),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedGender = newValue;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 15),

                // Password
                _buildTextField(passwordController, "Password", true),
                const SizedBox(height: 30),

                // Sign Up Button (Centered)
                Align(
                  alignment: Alignment.center,
                  child: ElevatedButton(
                    onPressed: register,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      padding: EdgeInsets.symmetric(
                        horizontal: screenWidth * 0.2, // Responsive button width
                        vertical: 15,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: screenWidth * 0.05, // Responsive font size
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// Helper function to build a text field
  Widget _buildTextField(TextEditingController controller, String hintText, bool obscureText, {TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black),
      decoration: InputDecoration(
        fillColor: Colors.grey.shade100,
        filled: true,
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.black, width: 2.0),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}
