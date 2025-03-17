
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shield_sister_2/backend/Authentication.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mongo_dart/mongo_dart.dart' as mongo;

class Contact {
  String name;
  String phone;

  Contact(this.name, this.phone);

  Map<String, String> toJson() {
    return {
      'name': name,
      'phone': phone,
    };
  }
}

class ContactManagementPage extends StatefulWidget {
  const ContactManagementPage({Key? key}) : super(key: key);

  @override
  _ContactManagementPageState createState() => _ContactManagementPageState();
}

class _ContactManagementPageState extends State<ContactManagementPage> {
  String userId = "";
  List<Contact> contactList = [];
  final AuthService authService = AuthService();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // Ensure userId is stored as a hex string (e.g. "67d6c9f8c18eb9b1663e6641")
      userId = prefs.getString('userId') ?? "";
    });
    print("User ID (hex string) is: $userId");
    _fetchContacts();
  }

  Future<void> _fetchContacts() async {
    try {
      final db = await mongo.Db.create(
        "mongodb+srv://gaznavisheikh01:gazi12345@cluster0.ms5wq.mongodb.net/test?retryWrites=true&w=majority&appName=Cluster0",
      );
      await db.open();
      final collection = db.collection("contacts");

      // Parse the userId hex string into an ObjectId for querying.
      final userObjectId = mongo.ObjectId.parse(userId);
      final contacts = await collection.find(mongo.where.eq('userId', userObjectId)).toList();
      await db.close();

      setState(() {
        contactList.clear();
        for (var doc in contacts) {
          contactList.add(Contact(doc['name'], doc['phone']));
        }
      });
    } catch (e) {
      print("Error fetching contacts: $e");
    }
  }

  Future<bool> _sendContactToBackend(String userId, Contact contact) async {
    final result = await authService.SaveContact(userId, contact);
    return result['message'] == "Contacts saved successfully!";
  }

  void _addContact() async {
    String name = _nameController.text.trim();
    String phone = _phoneController.text.trim();

    // Automatically prepend "+91 " if not already present.
    if (!phone.startsWith('+91')) {
      phone = '+91 ' + phone;
    }

    if (name.isNotEmpty && phone.isNotEmpty) {
      Contact newContact = Contact(name, phone);
      bool success = await _sendContactToBackend(userId, newContact);
      if (success) {
        setState(() {
          contactList.add(newContact);
        });
        _nameController.clear();
        _phoneController.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Contact successfully added", style: GoogleFonts.poppins()),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Failed to add contact", style: GoogleFonts.poppins()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _deleteContact(int index) {
    setState(() {
      contactList.removeAt(index);
    });
  }

  void _editContact(int index) {
    _nameController.text = contactList[index].name;
    _phoneController.text = contactList[index].phone;
    setState(() {
      contactList.removeAt(index);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Using a SingleChildScrollView wrapped around a Column ensures the page scrolls
    // even when the keyboard is visible or the list of contacts grows long.
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Contacts List", style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchContacts,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Contact Name Input
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: "Contact Name",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 10),
              // Phone Number Input
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: "Phone Number",
                  labelStyle: GoogleFonts.poppins(),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              // Save Contact Button
              ElevatedButton(
                onPressed: _addContact,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 45),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text("Save", style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 20),
              // Contacts List
              contactList.isEmpty
                  ? Center(child: Text("No contacts found", style: GoogleFonts.poppins()))
                  : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: contactList.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepOrangeAccent,
                        foregroundColor: Colors.white,
                        child: Text(
                          contactList[index].name[0].toUpperCase(),
                          style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                      ),
                      title: Text(
                        contactList[index].name,
                        style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        contactList[index].phone,
                        style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'Edit') {
                            _editContact(index);
                          } else if (value == 'Delete') {
                            _deleteContact(index);
                          }
                        },
                        itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            value: 'Edit',
                            child: Text('Edit', style: GoogleFonts.poppins()),
                          ),
                          PopupMenuItem<String>(
                            value: 'Delete',
                            child: Text('Delete', style: GoogleFonts.poppins()),
                          ),
                        ],
                        icon: const Icon(Icons.more_vert),
                      ),
                    ),
                  );
                },
              ),
              // Extra spacing to ensure the bottom items can be reached when scrolling.
              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }
}
