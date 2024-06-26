import 'package:flutter/material.dart';
import 'package:gp91/components/bottom_nav.dart';
import 'package:gp91/consumption/consumption_models.dart';
import 'package:gp91/consumption/fuel_firebase.dart';

class FuelResult extends StatelessWidget {
  // final String? consumptionDocumentId;
  // final String? carDocumentId;
  const FuelResult({
    super.key,
    //  this.consumptionDocumentId,
    //  this.carDocumentId,
  });

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
          'Fuel Consumption Results',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<Map<Car, List<ConsumptionRecord>>>(
        future: FuelFirebase().fetchCarsWithConsumptionRecords(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: CircularProgressIndicator(color: Color(0xFF6EA67C)));
          }
          // else if (snapshot.hasError) {
          //   return Center(child: Text('Error: ${snapshot.error}'));
          // } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          //   return Center(child: Text('No data available'));
          // }

          var carsWithRecords = snapshot.data!;
          return ListView.builder(
            itemCount: carsWithRecords.length,
            itemBuilder: (context, carIndex) {
              Car car = carsWithRecords.keys.elementAt(carIndex);
              List<ConsumptionRecord> records = carsWithRecords[car]!;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5), // Moderate padding
                      child: Text(
                        records.isEmpty
                            ? '${car.name}: No records yet'
                            : '${car.name}:',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(
                              255, 142, 142, 142), // Simple text color
                          shadows: [
                            Shadow(
                              offset: Offset(1.0, 1.0),
                              blurRadius: 3.0,
                              color: Colors.grey.withOpacity(0.5),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: records.length,
                    itemBuilder: (context, recordIndex) {
                      ConsumptionRecord record = records[recordIndex];

                      // Style the icon based on the percentageDifference
                      Icon arrowIcon;
                      if (record.percentageDifference!.contains('higher')) {
                        arrowIcon = const Icon(Icons.arrow_upward,
                            color: Colors.greenAccent, size: 20);
                      } else if (record.percentageDifference!
                          .contains('lower')) {
                        arrowIcon = const Icon(Icons.arrow_downward,
                            color: Colors.redAccent, size: 20);
                      } else {
                        arrowIcon = const Icon(Icons.horizontal_rule,
                            color: Colors.grey, size: 20);
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                color: Color.fromARGB(255, 161, 176, 164),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Text(
                                '${record.startDate} - ${record.endDate}',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 40.0,
                                    vertical: 40.0,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                      colors: [
                                        record.percentageDifference!
                                                .contains('lower')
                                            ? Color.fromARGB(255, 87, 185, 144)
                                            : Color.fromARGB(255, 207, 107,
                                                107), // Set gradient color based on percentageDifference
                                        record.percentageDifference!
                                                .contains('lower')
                                            ? Color.fromARGB(255, 11, 71, 46)
                                            : Color.fromARGB(255, 108, 27,
                                                27), // Set gradient color based on percentageDifference
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 1,
                                        blurRadius: 2,
                                        offset: const Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Fuel\nEconomy\n (${record.calculatedFuelEconomy})',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 4),
                                      // Set arrow color to white
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      color: theme.cardColor,
                                      borderRadius: BorderRadius.circular(12),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        '${record.percentageDifference}',
                                        style: const TextStyle(
                                          color:
                                              Color.fromARGB(255, 11, 71, 46),
                                        ),
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
                  const SizedBox(height: 20),
                ],
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 0, // Set the initial index as needed
        onIndexChanged: (index) {
          // Handle index changes if required
        },
      ),
    );
  }
}
