import 'package:flutter/material.dart';

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
        backgroundColor: Colors.white, // Set the app bar color to white
        centerTitle: true, // Center align the app bar text
        title: Text(
          'Settings',
          style: TextStyle(
            color: Color(0xFF6EA67C), // Set the app bar text color
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          color: Color(0xFF6EA67C),
          onPressed: () {
            Navigator.pop(context);
          },
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
                    // TODO: Implement log out logic
                    // AuthRepository().logout();
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
