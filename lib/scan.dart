import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ScanPage extends StatefulWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  _ScanPageState createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String qrCodeResult = "Not Yet Scanned";
  @override
  Widget build(BuildContext context) {

    CollectionReference qrcode = FirebaseFirestore.instance.collection('qrcode');

    return Scaffold(
      appBar: AppBar(
        title: Text("Scanner"),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[

           FutureBuilder<DocumentSnapshot>(
              future: qrcode.doc(qrCodeResult).get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

            if (snapshot.hasError) {
              return Text("Something went wrong");
            }

            if (snapshot.connectionState == ConnectionState.done) {
              Map<String, dynamic> data = snapshot.data.data();
              return Text("${data['name']}");
            }

            return Text("loading");
          },
        ),

            // StreamBuilder(
            //     stream: firestore.collection('qrcode').doc(qrCodeResult).snapshots(),
            //     builder: (context, snapshot) {
            //       var data = snapshot.data;
            //       if (!snapshot.hasData) return const Text('Loading...');
            //       if (qrCodeResult == "1234") {
            //         return Text(
            //           data["name"],
            //           style: TextStyle(
            //             fontSize: 20.0,
            //           ),
            //           textAlign: TextAlign.center,
            //         );
            //       } else {
            //         return Text(
            //           data["name"],
            //           style: TextStyle(
            //             fontSize: 20.0,
            //           ),
            //           textAlign: TextAlign.center,
            //         );
            //       }
            //    }),
            // Text(
            //   "Result",
            //   style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),

            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                String codeSanner =
                    await BarcodeScanner.scan(); //barcode scnner
                setState(() {
                  qrCodeResult = codeSanner;
                });

                // try{
                //   BarcodeScanner.scan()    this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;   we can print on the page that user has cancelled
                // }
              },
              child: Text(
                "Open Scanner",
                style:
                    TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
              ),
              shape: RoundedRectangleBorder(
                  side: BorderSide(color: Colors.blue, width: 3.0),
                  borderRadius: BorderRadius.circular(20.0)),
            )
          ],
        ),
      ),
    );
  }

  //its quite simple as that you can use try and catch statements too for platform exception
}
