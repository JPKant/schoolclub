import 'package:flutter/material.dart';

class genLoginSignupHeader extends StatelessWidget {
  String headerName;

  genLoginSignupHeader(this.headerName);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(height: 50.0),
          Text(
            'Bronx Science Club App',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black,
                fontSize: 35.0),
          ),
          SizedBox(height: 10.0),
          Image.asset(
            "assets/logo.png",
            height: 150.0,
            width: 150.0,
          ),
          SizedBox(height: 10.0),
          SizedBox(height: 10.0),
        ],
      ),
    );
  }
}
