import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<void> addCustomizationOptionsToFirebase()async{

  final FirebaseFirestore firestore = FirebaseFirestore.instance ;

  try{

    //get the json data file
    String jsonString = await rootBundle.loadString("assets/product_options.json");

    //parse the jsonString
    Map<String,dynamic> parsedJson = jsonDecode(jsonString);
    List<dynamic> productCustomizationOptions = parsedJson['product_customization_options'];
    print(productCustomizationOptions);

    //loop through the category and then add it to firebase
  }catch(e){
    print(e);
  }
}