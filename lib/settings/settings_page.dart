import 'package:flutter/material.dart';
import 'package:gp91/firebase_auth/user_repository/auth_repository.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isArabicSelected = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6EA67C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SwitchListTile(
                    value: isArabicSelected,
                    onChanged: (value) {
                      setState(() {
                        isArabicSelected = value;
                      });
                    },
                    title: Text('Language'),
                    subtitle:
                        isArabicSelected ? Text('العربية') : Text('English'),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.center,
              child: SizedBox(
                width: double
                    .infinity, // Make the button take the full available width
                child: ElevatedButton(
                  onPressed: () {
                    // AuthRepository().logout();
                    AuthRepository().logoutAndNavigateToWelcomePage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Color(0xFF6EA67C), // Set the button background color
                  ),
                  child: Text('Log Out'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
