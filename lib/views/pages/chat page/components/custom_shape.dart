import 'package:flutter/material.dart';
import 'package:secondhand/constants/colors.dart';

class RPSCustomPainter extends CustomPainter{
  
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint0 = Paint()
      ..color = kPrimaryColor
      ..style = PaintingStyle.fill
      ..strokeWidth = 16.2;
     
         
    Path path0 = Path();
    path0.moveTo(0,0);
    path0.lineTo(size.width*0.8066000,0);
    path0.quadraticBezierTo(size.width*1.0963000,size.height*0.0669000,size.width*0.8000000,size.height*0.2500000);
    path0.quadraticBezierTo(size.width*0.6000000,size.height*0.3383250,0,size.height*0.6033000);

    canvas.drawPath(path0, paint0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}
