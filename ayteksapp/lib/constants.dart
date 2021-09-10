import 'package:flutter/material.dart';


const kMesajTextFieldDecoration=InputDecoration(
  filled: true,
  fillColor: Color(0xFF32CD32),
  contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
  hintText: 'Mesajınızı yazınız...',
  hintStyle: TextStyle(color: Colors.white),
  border: InputBorder.none
);

const kMesajContainerDecoration=BoxDecoration(
  border: Border(
      top: BorderSide(color:Color(0xFF32CD32),width: 2.0)
  ));