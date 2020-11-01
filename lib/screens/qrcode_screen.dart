import 'package:flutter/material.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'package:url_launcher/url_launcher.dart';

class QRCode extends StatefulWidget {
  @override
  _QRCodeState createState() => _QRCodeState();
}

class _QRCodeState extends State<QRCode> {
  String qrCodeResult = "Not Yet Scanned";
  bool hasData = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.black87,
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    "Result:  ${(qrCodeResult)}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.launch_outlined),
                  onPressed: hasData
                      ? () async {
                          if (await canLaunch(qrCodeResult)) {
                            print(qrCodeResult);
                            await launch(qrCodeResult);
                          } else {
                            throw 'Could not launch ';
                          }
                        }
                      : null,
                ),
              ],
            ),
            // Text(
            //   "Result",
            //   style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
            //   textAlign: TextAlign.center,
            // ),
            // Text(
            //   qrCodeResult,
            //   style: TextStyle(
            //     fontSize: 20.0,
            //   ),
            //   textAlign: TextAlign.center,
            // ),
            SizedBox(
              height: 20.0,
            ),
            FlatButton(
              padding: EdgeInsets.all(15.0),
              onPressed: () async {
                String codeScanner = await scanner.scan();
                setState(() {
                  qrCodeResult = codeScanner;
                  hasData = true;
                });

                // try{
                //   BarcodeScanner.scan()
                //   this method is used to scan the QR code
                // }catch (e){
                //   BarcodeScanner.CameraAccessDenied;
                //   we can print that user has denied for the permisions
                //   BarcodeScanner.UserCanceled;
                //   we can print on the page that user has cancelled
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
}
