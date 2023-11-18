import 'package:flutter/material.dart';

class FuelResult extends StatelessWidget {
  const FuelResult({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> items =
        List<String>.generate(3, (index) => "Item ${index + 1}");

    return Scaffold(
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Column(
              children: <Widget>[
                const Text(
                  // retrieved from consumption
                  '1/8/2023 - 30/8/2023',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment
                      .center, // Adjust alignment if necessary
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50.0,
                        vertical: 30.0,
                      ),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 2,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            // retrieved from consumption
                            '17.2',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          SizedBox(width: 4),
                          Icon(
                            Icons.arrow_upward,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(
                            items[index],
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                          ),
                          subtitle: Text(
                            // retrieved from consumption
                            '40% higher than the default',
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
