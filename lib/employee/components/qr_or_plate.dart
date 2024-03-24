import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:gp91/employee/plate.dart';
import 'package:gp91/employee/report_bill.dart';

class QRorPlate extends StatefulWidget {
  final String email;

  QRorPlate({required this.email});

  @override
  _QRorPlateState createState() => _QRorPlateState();
}

class _QRorPlateState extends State<QRorPlate> {
  String? _qrCodeResult;

  Future<void> _scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.QR,
      );

      if (qrCode != '-1' && qrCode != 'QR Code Result') {
        setState(() {
          _qrCodeResult = qrCode;
        });
      }

      print("QRCode_Result:--");
      print(qrCode);
    } on PlatformException {
      print('Failed to scan QR Code.');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

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
          'Report Bill',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: 60),
            Image.asset(
              'assets/images/start.gif',
              width: 200,
              height: 200,
            ),
            SizedBox(height: 12),
            const Text(
              "Choose The Report Bill Method",
              style: TextStyle(
                color: Color.fromRGBO(54, 80, 61, 1),
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: _scanQRCode,
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/1.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.contain,
                        //  color: Color.fromARGB(255, 174, 174, 172),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Scan QR',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 50),
                InkWell(
                  onTap: () {
                    Get.to(() => PlantPage(
                          email: widget.email,
                        ));
                  },
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/images/2.png",
                        width: 100,
                        height: 100,
                        //color: Color.fromARGB(255, 208, 206, 200),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Plate Number',
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            //  SizedBox(height: size.height * 0.04),
            if (_qrCodeResult != null) ...[
              Text(
                'Scanned QR Code: $_qrCodeResult',
                style: TextStyle(fontSize: 18),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ReportBill(
                          documentId: _qrCodeResult!, email: widget.email),
                    ),
                  );
                },
                child: Text('View Report'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
