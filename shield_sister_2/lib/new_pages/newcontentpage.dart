import 'package:flutter/material.dart';

class NewContentPage extends StatefulWidget {
  const NewContentPage({super.key});

  @override
  State<NewContentPage> createState() => _NewContentPageState();
}

class _NewContentPageState extends State<NewContentPage> {

  final List<Article> articles = [
    Article(
        title: "What is a SOS?",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST4Yzb80_jIgbz17IQ2I18qii1gqDneHZfnw&s",
        description: "Tips on staying alert in public places.",
        content: "Always be aware of your surroundings and trust your instincts."),
    Article(
        title: "Self Defense Techniques",
        imageUrl: "assets/images/womenDefence.jpg",
        description: "Learn simple and effective self-defense techniques.",
        content:
        "Basic moves that can help protect yourself in dangerous situations."),
  ];

  final List<SafetyManual> manuals = [
    SafetyManual(
        title: "What is a SOS?",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcST4Yzb80_jIgbz17IQ2I18qii1gqDneHZfnw&s",
        content: " the SOS (Save our Souls) feature sends an alert to emergency services or contacts when a user needs immediate assistance.\n The alert includes the user's location, battery percentage, and other information."
    ),
    SafetyManual(
        title: "How to make SOS alert?",
        imageUrl: "https://img.freepik.com/premium-vector/sos-notification-screen-phone-sos-emergency-call-phone-911-call-screen-smartphone-cry-help-calling-help-vector-stock-illustration_435184-1303.jpg",
        content: "The SOS feature is embedded in our home page.\n\n Follow the steps:\n1. Open the homepage.\n2. Click on the SOS button in the center\n3. If a dropdown message is recieved then the SOS is successfully sent"
    ),
    SafetyManual(
        title: "How to add Contacts?",
        imageUrl: "https://img.freepik.com/free-vector/mobile-inbox-concept-illustration_114360-4014.jpg",
        content: "Follow the simple steps to add contact:\n1. Visit Contact page from Navigation bar on the bottom\n2. Add contact details and hit save\n3. The card will appear with name and details."
    ),
    SafetyManual(
        title: "How to locate Safe-Zones?",
        imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRPfNxeXYCh6YJS_mZGGh-8HE6FQEUlHAOB2g&s",
        content: "Safe zones are safety location marked on the map.\n\nFollow the steps to track safe zones\n1. Go to Map section from bottom Navigation bar\n2. Click on the track safe zones button\n3. The nearest safe zone will be tracked on the map screen."
    ),

  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Column(
          children: [
          //   Start of the Column
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.greenAccent,
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _topButtons("How to access?"),
                      _topButtons("Safety Blogs"),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _topButtons("Quick Manuals"),
                      _topButtons("Misc"),
                    ],
                  ),
                  const SizedBox(height: 20,),
                ],
              )
            ), // This is the starting container with main buttons
            SingleChildScrollView(
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: manuals.length,
                  itemBuilder: (context, index) {
                    final manual = manuals[index];
                    return GestureDetector(
                      onTap: () => showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(manual.title, style: TextStyle(fontSize: 28),),
                          content: Text(manual.content, style: TextStyle(fontSize: 18, color: Colors.grey[800])),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Close"),
                            ),
                          ],
                        ),
                      ),
                      child: Card(
                        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        elevation: 4,
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                manual.imageUrl,
                                height: 100,
                                width: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    manual.title,
                                    style: TextStyle(
                                        fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
            )
          // End of the column
          ],
        ),
      ),
    );
  }
}

Widget _topButtons(String name) => Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
  ),
  width: 190,
  child: Center( // Centering the text button
    child: TextButton( // adding the text button
      onPressed: (){},
      child: Text(name,
        style: TextStyle( // text style
          color: Colors.black,
          fontSize: 22,
        ),
      ),
    ),
  ),
);

Widget _accessManual(String imageName, String question)=> Card(
  margin: EdgeInsets.only(bottom: 15),
  elevation: 3,
  color: Colors.white,
  child: Row(
    children: [
      Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
        ),
        width: 100,
        height: 100,
        child: Image.network(imageName, fit: BoxFit.cover,),
      ), // Added image here with custom height and width
      Container(
        child: Text(question,
          style:TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
      ),

    ],
  ),
);


class Article {
  final String title;
  final String imageUrl;
  final String description;
  final String content;

  Article({
    required this.title,
    required this.imageUrl,
    required this.description,
    required this.content,
  });
}

class SafetyManual {
  final String title;
  final String imageUrl;
  final String content;

  SafetyManual({
    required this.title,
    required this.imageUrl,
    required this.content,
  });
}
