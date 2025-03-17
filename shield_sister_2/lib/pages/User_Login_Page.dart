import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserLoginPage extends StatefulWidget {
  const UserLoginPage({Key? key}) : super(key: key);

  @override
  _UserLoginPageState createState() => _UserLoginPageState();
}

final ThemeData theme = ThemeData(
  textTheme: GoogleFonts.poppinsTextTheme(),
);

class _UserLoginPageState extends State<UserLoginPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email and Password cannot be empty')),
      );
      return;
    }

    try {
      final result = await authService.login(email, password);

      if (result.containsKey('message') &&
          result['message'] == 'Login successful') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userId', result['user']['_id']);
        await prefs.setString('jwtToken', result['token']);
        await prefs.setString('username', result['user']['fullname']);
        await prefs.setString('email', result['user']['email']);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login Successful')),
        );
        Navigator.pushReplacementNamed(context, '/bot');
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(result['message'] ?? 'Unknown error occurred')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An unexpected error occurred: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double paddingValue = screenWidth * 0.1; // Responsive padding

    return Scaffold(
      backgroundColor: Color(0xFFDFF3EA),
      body: Stack(
        children: [
          // Custom Background Circles
          CustomPaint(
            size: Size(screenWidth, MediaQuery.of(context).size.height),
            painter: BlackBackgroundPainter(),
          ),

          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: paddingValue),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.1),

                    // Login Title
                    Text(
                      'Login',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: screenWidth * 0.1, // Responsive font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    SizedBox(height: 40),

                    // Email TextField
                    TextField(
                      style: TextStyle(color: Colors.black),
                      controller: emailController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Email",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 30),

                    // Password TextField
                    TextField(
                      obscureText: true,
                      controller: passwordController,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade100,
                        filled: true,
                        hintText: "Password",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),

                    SizedBox(height: 40),

                    // Login Button (Circle)
                    Align(
                      alignment: Alignment.centerRight,
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.black,
                        child: IconButton(
                          color: Colors.white,
                          onPressed: login,
                          icon: Icon(Icons.arrow_forward),
                        ),
                      ),
                    ),

                    SizedBox(height: 80),

                    // Sign Up & Forgot Password Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/reg');
                          },
                          child: Text(
                            'Sign Up',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize:
                                  screenWidth * 0.05, // Responsive text size
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: Text(
                            'Forgot Password',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: screenWidth * 0.05,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Custom Painter for Circles
class BlackBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..color = Colors.black;

    // Circle 1
    canvas.drawCircle(
      Offset(size.width * 0.1, size.height * 0.88), // Adjusted position
      size.width * 0.33, // Responsive radius
      paint,
    );

    // Circle 2
    canvas.drawCircle(
      Offset(size.width * 0.5, size.height * 0.90),
      size.width * 0.44,
      paint,
    );

    // Circle 3
    canvas.drawCircle(
      Offset(size.width * 0.9, size.height * 0.88),
      size.width * 0.33,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
