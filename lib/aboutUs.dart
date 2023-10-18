import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  @override
  _AboutUsPageState createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Map<String, bool> _sectionsExpandedState = {
    'Who Are We?': false,
    'Contact Us': false,
    'Privacy Policy': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white, // Set the app bar color to white
        centerTitle: true, // Center align the app bar text
        title: Text(
          'About Us',
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
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: _buildSections(),
      ),
    );
  }

  List<Widget> _buildSections() {
    return _sectionsExpandedState.entries.map((entry) {
      final sectionTitle = entry.key;
      final isExpanded = entry.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text(
              sectionTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6EA67C),
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _sectionsExpandedState[sectionTitle] = !isExpanded;
              });
            },
          ),
          if (isExpanded) _buildSectionContent(sectionTitle),
          Divider(),
        ],
      );
    }).toList();
  }

  Widget _buildSectionContent(String sectionTitle) {
    String sectionContent = '';

    // Set the section content based on the section title
    switch (sectionTitle) {
      case 'Who Are We?':
        sectionContent = 'This is the "Who Are We?" section content.';
        break;
      case 'Contact Us':
        sectionContent = 'This is the "Contact Us" section content.';
        break;
      case 'Privacy Policy':
        sectionContent = 'This is the "Privacy Policy" section content.';
        break;
    }

    return Padding(
      padding: EdgeInsets.only(left: 16.0),
      child: Text(sectionContent),
    );
  }
}
