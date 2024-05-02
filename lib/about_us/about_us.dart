import 'package:flutter/material.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});
  @override
  State<StatefulWidget> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  final Map<String, bool> _sectionsExpandedState = {
    // all the values are false so none of it opens automaticallywhem the page is open
    'Who Are We?': false,
    'Contact Us': false,
    'Privacy Policy': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF6EA67C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'About Us',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
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
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF6EA67C),
              ),
            ),
            trailing: Icon(
              isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            iconColor: Color(0xFF0C9869),
            onTap: () {
              setState(() {
                _sectionsExpandedState[sectionTitle] = !isExpanded;
              });
            },
          ),
          if (isExpanded) _buildSectionContent(sectionTitle),
          const Divider(),
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
      padding: const EdgeInsets.only(left: 16.0),
      child: Text(sectionContent),
    );
  }
}
