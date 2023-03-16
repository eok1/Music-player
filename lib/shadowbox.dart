import 'package:flutter/material.dart';

class Shadowbox extends StatelessWidget {
   final child;
const Shadowbox({ Key? key, required this.child }) : super(key: key);

  @override
  Widget build(BuildContext context){
    return  Container(
      padding: EdgeInsets.all(12),
        child: Center(
           child:  child,
        ),
       
         decoration:  BoxDecoration(
           color: Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
           boxShadow: [
            BoxShadow(
              color: Colors.grey.shade500,
              offset:  const Offset(5,5),
              blurRadius:  15,
            ),
             BoxShadow(
              color: Colors.white,
              offset:  const Offset(-5,-5),
              blurRadius:  15,
            )
           ]

         ),
      );
  }
}