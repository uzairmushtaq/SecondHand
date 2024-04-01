import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:secondhand/constants/colors.dart';
import 'package:secondhand/constants/icons.dart';
import 'package:secondhand/utils/root.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    
    super.initState();
   onGoingToRoot();
  }
  @override
  void dispose() {
    super.dispose();
    
  }
  Future<void> onGoingToRoot()async{
    await  Future.delayed(
        const Duration(seconds: 2),
            () => Navigator.pushAndRemoveUntil<dynamic>(
          context,
          MaterialPageRoute<dynamic>(
            builder: (BuildContext context) => Root(),
          ),
              (route) => false,
        ));
  }

  @override
  Widget build(BuildContext context) {
    return MediaQuery(
       data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: Scaffold(
        backgroundColor: kPrimaryColor,
        body: Center(child: Image.asset(
          "assets/icons/appLOGO.png",
          color: kPrimaryColor,
        ))
      ),
    );
  }
}
