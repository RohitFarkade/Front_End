import "package:cloud_firestore/cloud_firestore.dart";
import "package:flutter/material.dart";
import 'prot1_myapp.dart' as protMyApp;

class AddContactPage extends StatefulWidget {
  const AddContactPage({Key? key}) : super(key: key);

  @override
  State<AddContactPage> createState() => AddContactScreen();
}

class AddContactScreen extends State<AddContactPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  List<Contact> contacts = List.empty(growable: true);

  int selectedIndex = -1;

  List<String> name_list = [];
  List<String> email_list = [];

  Future<void> UpdateContacts() async {

    CollectionReference sosAlerts = FirebaseFirestore.instance.collection('contactscoll1');
    var thatUnique = protMyApp.random_uniqueID;

    for(int i=0; i < name_list.length; i++){
      await sosAlerts.add({
        'User_ID': '$thatUnique',
        'contact_name': name_list[i],
        'contact_mail': email_list[i],
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Contacts List'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            const SizedBox(height: 10),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                  hintText: 'Contact Name',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                  hintText: 'Email ID',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ))),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    String name = nameController.text.trim();
                    String email = emailController.text.trim();
                    if (name.isNotEmpty && email.isNotEmpty) {
                      name_list.add(name);
                      email_list.add(email);
                      setState(() {
                        nameController.text = '';
                        emailController.text = '';
                        contacts.add(Contact(name: name, email: email));
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Optional, for rounded edges
                      side: const BorderSide(color: Colors.black, width: 2), // Bold border
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold), // Optional, for bold text
                  ),
                ),

                ElevatedButton(
                    onPressed: () {
                      String name = nameController.text.trim();
                      String email = emailController.text.trim();
                      if (name.isNotEmpty && email.isNotEmpty) {
                        UpdateContacts();
                        setState(() {
                          nameController.text = '';
                          emailController.text = '';
                          contacts[selectedIndex].name = name;
                          contacts[selectedIndex].email = email;
                          selectedIndex = -1;
                        });
                      }
                    },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Optional, for rounded edges
                      side: const BorderSide(color: Colors.black, width: 2), // Bold border
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontWeight: FontWeight.bold), // Optional, for bold text
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            contacts.isEmpty
                ? const Text(
              'No Contact yet..',
              style: TextStyle(fontSize: 22),
            )
                : Expanded(
              child: ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) => getRow(index),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getRow(int index) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
          index % 2 == 0 ? Colors.deepPurpleAccent : Colors.purple,
          foregroundColor: Colors.white,
          child: Text(
            contacts[index].name[0],
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contacts[index].name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(contacts[index].email),
          ],
        ),
        trailing: SizedBox(
          width: 70,
          child: Row(
            children: [
              InkWell(
                  onTap: () {
                    nameController.text = contacts[index].name;
                    emailController.text = contacts[index].email;
                    setState(() {
                      selectedIndex = index;
                    });
                  },
                  child: const Icon(Icons.edit)),
              InkWell(
                  onTap: (() {
                    setState(() {
                      contacts.removeAt(index);
                    });
                  }),
                  child: const Icon(Icons.delete)),
            ],
          ),
        ),
      ),
    );
  }
}

class Contact {
  String name;
  String email;
  Contact({required this.name, required this.email});
}
