import 'package:flutter/material.dart';
class TestPage extends StatelessWidget {
  const TestPage({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Test"),
      ),
      body: Center(
        child: 
        Text("Check wriggles or not"),
      ),
    );
  }
}