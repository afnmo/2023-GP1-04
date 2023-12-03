import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gp91/station/details_station/detailsStation.dart';

//This Page Display The List Of Station In Station Page -----------------

// Widget to display a list of stations
class StationList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Station').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return Column(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> stationData =
                  document.data() as Map<String, dynamic>;

              if (stationData['image_station'] != null) {
                return StationCard(
                  name: stationData['name'], //name station
                  state: 'Busy', // it will be implemented in sprint 3
                  fuelTypeState: stationData[
                      'fuel_status'], // the state for each type of fuel
                  imgStation: stationData['image_station'], //image of station
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsStation(
                          id: document.id,
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Handle the case when image_station is null
                return Container(); // Empty container as a placeholder
              }
            }).toList(),
          );
        },
      ),
    );
  }
}

// Widget for displaying each station card
class StationCard extends StatelessWidget {
  const StationCard({
    Key? key,
    required this.name,
    required this.state,
    required this.imgStation,
    this.onTap,
    required this.fuelTypeState,
  }) : super(key: key);

  final name, state, imgStation;
  final onTap;
  final List<dynamic> fuelTypeState;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap();
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 22, vertical: 10),
        width: MediaQuery.of(context).size.width,
        height: 180,
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: Offset(
                0.0,
                10.0,
              ),
              blurRadius: 10.0,
              spreadRadius: -6.0,
            ),
          ],
          image: DecorationImage(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.35),
              BlendMode.multiply,
            ),
            image: NetworkImage('$imgStation'),
            fit: BoxFit.cover,
          ),
        ),
        child: Stack(
          children: [
            Align(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
              ),
              alignment: Alignment.center,
            ),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 249, 245, 245).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: Color.fromARGB(255, 232, 36, 6),
                          size: 18,
                        ),
                        SizedBox(width: 7),
                        Text(state),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 245, 243, 243)
                          .withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        // Insert the for loop here to display SVG icons based on fuelTypeState.

                        for (int i = 0; i < fuelTypeState.length; i++)
                          if (fuelTypeState[i].substring(0, 2) == '91' &&
                              fuelTypeState[i].substring(3, 12) == 'Available')
                            SvgPicture.asset(
                              'assets/icons/91A.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuelTypeState[i].substring(0, 2) == '91' &&
                              fuelTypeState[i].substring(3, 14) ==
                                  'Unavailable')
                            SvgPicture.asset(
                              'assets/icons/91U.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuelTypeState[i].substring(0, 2) == '95' &&
                              fuelTypeState[i].substring(3, 12) == 'Available')
                            SvgPicture.asset(
                              'assets/icons/95A.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuelTypeState[i].substring(0, 2) == '95' &&
                              fuelTypeState[i].substring(3, 14) ==
                                  'Unavailable')
                            SvgPicture.asset(
                              'assets/icons/95U.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuelTypeState[i].substring(0, 6) ==
                                  'Diesel' &&
                              fuelTypeState[i].substring(7, 16) == 'Available')
                            SvgPicture.asset(
                              'assets/icons/DA.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuelTypeState[i].substring(0, 6) ==
                                  'Diesel' &&
                              fuelTypeState[i].substring(7, 18) ==
                                  'Unavailable')
                            SvgPicture.asset(
                              'assets/icons/Du.svg',
                              width: 45,
                              height: 45,
                            ),
                      ],
                    ),
                  ),
                ],
              ),
              alignment: Alignment.bottomLeft,
            ),
          ],
        ),
      ),
    );
  }
}
