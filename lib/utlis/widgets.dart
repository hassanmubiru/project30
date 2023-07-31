import 'package:flutter/material.dart';

InputDecoration  buildInputDecoration(String hinText,IconData icon){
  return InputDecoration(
    prefixIcon: Icon(icon,color:Colors.black ,),
    contentPadding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(5))
  );
}
label (String title) => Text(title);
MaterialButton longButtons(String title,Function fun,{Color color = Colors.black,Color textColor=Colors.white,}){
  return MaterialButton(
    onPressed: (){
      fun;
    },
    textColor: textColor,
    color: color,
    child: SizedBox(
      width: double.infinity,
      child: Text(title),
    ),
    
    );
}