import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserProfileScreen extends StatefulWidget {
  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers to get input from TextFormFields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),

      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          key: _formKey,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: <Widget>[

                Center(
                  child: CircleAvatar(
                    radius: 50,
                    child: Image.asset('assets/images/image7.jpg'), // image
                    backgroundColor: Color.fromRGBO(169, 214, 193, 100),
                  ),
                ),
                // Name Field
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                    contentPadding: EdgeInsets.only(bottom: 40),
                  ),

                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // Email Field
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email', labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),contentPadding: EdgeInsets.only(bottom: 40)),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // Phone Number Field
                TextFormField(
                  controller: _phoneController,
                  decoration: InputDecoration(labelText: 'Phone Number', labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),contentPadding: EdgeInsets.only(bottom: 40),),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    } else if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Please enter a valid phone number';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16.0),
                // Address Field
                TextFormField(
                  controller: _addressController,
                  decoration: InputDecoration(labelText: 'Address', labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),contentPadding: EdgeInsets.only(bottom: 40),),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your address';
                    }
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 170.0, top: 20.0), // Apply padding on the left
                  child: SizedBox(
                    width: 180,
                    height: 45, // Set the height of the SizedBox

                    child: ElevatedButton( // Submit Button inside SizedBox
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          // Process data
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Processing Data')),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  Colors.black, // the background color here
                      ),
                      child: Text('LogOut', style: TextStyle(color:Colors.white, fontSize: 20)),
                    ),
                  ),
                )

              ] ),

        ),
      ),
    );
  }
}
