import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditUserName extends StatefulWidget {
  EditUserName({this.callBack});
  final Function callBack;

  @override
  _EditUserNameState createState() => _EditUserNameState();
}

class _EditUserNameState extends State<EditUserName> {
  String userName;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(30.0),
              child: TextFormField(
                decoration: InputDecoration(
                  labelText: "User Name",
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25.0),
                    borderSide: BorderSide(),
                  ),
                ),
                validator: (name) {
                  Pattern pattern = r'^[A-Za-z0-9]+(?:[ _-][A-Za-z0-9]+)*$';
                  RegExp regex = new RegExp(pattern);
                  if (!regex.hasMatch(name))
                    return 'Invalid username';
                  else
                    return null;
                },
                onChanged: (newText) {
                  userName = newText;
                },
                keyboardType: TextInputType.text,
                style: GoogleFonts.poppins(),
              ),
            ),
            SizedBox(height: 10.0),
            RaisedButton(
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  widget.callBack(userName);
                }
              },
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ),
              child: Text('Edit User Name'),
            ),
          ],
        ),
      ),
    );
  }
}
