import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'Details_Station/Details_Station.dart';
import 'package:flutter_svg/flutter_svg.dart';

//THIS PAGE DISPLAY THE LIST OF STATION IN STATION PAGE:
//HERE I WILL USE DATABASE TO FETCH STATION COLLECTION:

class Station_list extends StatelessWidget {
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
                return RecipeCard(
                  name: stationData['name'],
                  state: 'Busy', // it will implement in sprint 3
                  fuel_type_state: stationData['fuel_status'],
                  // fuel_state: stationData['fuel_state'],
                  img_station: stationData['image_station'],
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Details_Station(
                          id: document.id,
                        ),
                      ),
                    );
                  },
                );
              } else {
                // Handle the case when image_station is null
                // You can return a different widget or handle it as needed.
                return Container(); // Empty container as a placeholder
              }
            }).toList(),
          );
        },
      ),
    );
  }
}

//HERE THE CLASS OF STATION INFRO! :

// Import the flutter_svg package.

class RecipeCard extends StatelessWidget {
  const RecipeCard({
    Key? key,
    required this.name,
    required this.state,
    required this.img_station,
    this.onTap,
    // required this.fuel_type,
    //required this.fuel_state,
    required this.fuel_type_state,
  }) : super(key: key);

  final name, state, img_station;
  final onTap;
  final List<dynamic> fuel_type_state;

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
            image: NetworkImage('$img_station'),
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
                        // Insert the for loop here to display SVG icons based on fuel_type and fuel_state.

                        for (int i = 0; i < fuel_type_state.length; i++)
                          if (fuel_type_state[i].substring(0, 2) == '91' &&
                              fuel_type_state[i].substring(3, 12) ==
                                  'Available')
                            SvgPicture.asset(
                              'assets/icons/91A.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuel_type_state[i].substring(0, 2) == '91' &&
                              fuel_type_state[i].substring(3, 14) ==
                                  'Unavailable')
                            SvgPicture.asset(
                              'assets/icons/91U.svg',
                              width: 25,
                              height: 25,
                            )
                          else if (fuel_type_state[i].substring(0, 2) == '95' &&
                              fuel_type_state[i].substring(3, 12) ==
                                  'Available')
                            SvgPicture.asset(
                              'assets/icons/95A.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuel_type_state[i].substring(0, 2) == '95' &&
                              fuel_type_state[i].substring(3, 14) ==
                                  'Unavailable')
                            SvgPicture.asset(
                              'assets/icons/95U.svg',
                              width: 25,
                              height: 25,
                            )
                          else if (fuel_type_state[i].substring(0, 6) ==
                                  'Diesel' &&
                              fuel_type_state[i].substring(7, 16) ==
                                  'Available')
                            SvgPicture.asset(
                              'assets/icons/DA.svg',
                              width: 45,
                              height: 45,
                            )
                          else if (fuel_type_state[i].substring(0, 6) ==
                                  'Diesel' &&
                              fuel_type_state[i].substring(7, 18) ==
                                  'Unavailable')
                            SvgPicture.asset(
                              'assets/icons/Du.svg',
                              width: 25,
                              height: 25,
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
