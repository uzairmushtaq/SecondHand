import 'package:flutter/material.dart';
class CustomSenderShape extends CustomPainter{
  @override
  void paint(Canvas canvas, Size size) {
    
    

  Paint paint0 = Paint()
      ..color = const Color(0xFF779EA3)
      ..style = PaintingStyle.fill
      ..strokeWidth = 16.2;
     
         
    Path path0 = Path();
    path0.moveTo(size.width,0);
    path0.lineTo(size.width*0.1100000,size.height*0.0033000);
    path0.quadraticBezierTo(size.width*-0.0363000,size.height*0.0562000,size.width*0.1100000,size.height*0.1900000);
    path0.quadraticBezierTo(size.width*0.3325000,size.height*0.2725250,size.width,size.height*0.5201000);

    canvas.drawPath(path0, paint0);
  
    
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
  
}
