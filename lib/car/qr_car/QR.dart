import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QR extends StatelessWidget {
  final String carId;

  QR({Key? key, required this.carId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // App bar styling
        backgroundColor: Color(0xFF6EA67C),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: const Text(
          'QR Code',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: [
          // Background Image
          Image.asset(
            'assets/images/QR_background.gif',
            width: 500,
            height: 500,
          ),
          // QR code
          QrImageView(
            data: carId,
            version: QrVersions.auto,
            size: 330.0,
            foregroundColor: Color.fromARGB(255, 183, 172, 172),
          ),
          // Car ID text
          // Positioned(
          //   bottom: 20,
          //   child: Text('Car ID: $carId', style: TextStyle(fontSize: 20)),
          // ),
        ],
      ),
    );
  }
}
