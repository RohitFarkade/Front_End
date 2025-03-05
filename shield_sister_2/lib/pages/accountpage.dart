import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Profile_widgets.dart';

class AccPage extends StatelessWidget {
  const AccPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        body: SingleChildScrollView(padding: const EdgeInsets.fromLTRB(10, 30, 10, 0),
          child: Container(
            padding: const EdgeInsets.all(20),
            height: size.height,
            width: size.width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  child: const CircleAvatar(
                    radius: 60,
                    backgroundImage: ExactAssetImage('assets/images/image7.jpg'),
                  ),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      //color: Constants.primaryColor.withOpacity(.5),
                      width: 5.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: size.width * .3,
                  child: const Row(
                    children: [
                      Text(
                        'John Doe',
                        style: TextStyle(
                          //color: Constants.blackColor,
                          fontSize: 20,
                        ),
                      ),
                    ]
                  ),
                ),
                Text(
                  'johndoe@gmail.com',
                  style: TextStyle(
                    //color: Constants.blackColor.withOpacity(.3),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                SizedBox(
                  height: size.height * .7,
                  width: size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      ProfileWidget(
                        icon: Icons.person,
                        title: 'My Profile',
                      ),
                      ProfileWidget(
                        icon: Icons.settings,
                        title: 'Settings',
                      ),
                      ProfileWidget(
                        icon: Icons.notifications,
                        title: 'Notifications',
                      ),
                      ProfileWidget(
                        icon: Icons.chat,
                        title: 'FAQs',
                      ),
                      // ProfileWidget(
                      //   icon: Icons.share,
                      //   title: 'Share',
                      // ),
                      ProfileWidget(
                        icon: Icons.logout,
                        title: 'Log Out',
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
