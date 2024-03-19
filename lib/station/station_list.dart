import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gp91/station/details_station/details_station.dart';

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
                  name: stationData['name'],
                  state: 'Busy',
                  fuelTypeState: stationData['fuel_status'],
                  imgStation: stationData['image_station'],
                  promotion: stationData['promotions'],
                  current: stationData['current'],
                  maximum: stationData['maximum'],
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
                return Container();
              }
            }).toList(),
          );
        },
      ),
    );
  }
}

class StationCard extends StatelessWidget {
  const StationCard({
    Key? key,
    required this.name,
    required this.state,
    required this.imgStation,
    this.onTap,
    required this.fuelTypeState,
    required this.promotion,
    required this.maximum,
    required this.current,
  }) : super(key: key);

  final name, state, imgStation, maximum, current;
  final onTap;
  final List<dynamic>? promotion;
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
            if (_shouldDisplayPromotions())
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 200, 78, 119).withOpacity(0.5),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.percent_outlined,
                        color: Color.fromARGB(255, 248, 246, 246),
                        size: 14,
                      ),
                      SizedBox(width: 7),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          for (var pro in promotion!)
                            if (_isValidPromotion(pro))
                              Text(
                                pro['promotion'].toString(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1!
                                    .copyWith(
                                      color: Color.fromARGB(255, 250, 250, 250),
                                      fontSize: 14,
                                    ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            Align(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (maximum == current)
                          ? Colors.red.withOpacity(
                              0.5) // If busy, container color is red
                          : ((maximum / 2) == current)
                              ? Colors.orange.withOpacity(
                                  0.5) // If little busy, container color is orange
                              : Colors.green.withOpacity(
                                  0.5), // Otherwise, container color is green
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
                        if (maximum == current)
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color.fromARGB(255, 232, 36, 6),
                                size: 20,
                              ),
                              Text(
                                'Busy',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 252, 251, 251),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        else if ((maximum / 2) == current)
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color.fromARGB(255, 228, 181, 11),
                                size: 20,
                              ),
                              Text(
                                'Little Busy',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 249, 249, 248),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          )
                        else
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color.fromARGB(255, 6, 233, 6),
                                size: 20,
                              ),
                              Text(
                                'Available',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 251, 252, 250),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(5),
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color:
                          Color.fromARGB(255, 243, 241, 241).withOpacity(0.4),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: [
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

// Function to validate a promotion
  bool _isValidPromotion(Map<String, dynamic> promotion) {
    if (promotion['start'] == null || promotion['end'] == null) {
      return false; // Promotion is invalid if start or end date is null
    }
    DateTime? startDate = DateTime.tryParse(promotion['start'] ?? '');
    DateTime? endDate = DateTime.tryParse(promotion['end'] ?? '');
    return endDate != null && startDate != null && endDate.isAfter(startDate) ||
        endDate!.isAtSameMomentAs(
            startDate!); // Promotion is valid if end date is after or equal to start date
  }

  bool _shouldDisplayPromotions() {
    if (promotion == null || promotion!.isEmpty) {
      return false; // No promotions available so no container will display
    }
    for (var promo in promotion!) {
      if (_isValidPromotion(promo)) {
        return true; // At least one promotion is valid
      }
    }
    return false; // All promotions are invalid
  }
}
