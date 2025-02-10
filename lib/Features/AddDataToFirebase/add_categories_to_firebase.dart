import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<void> addCategoriesToFirebase () async{
  final FirebaseFirestore firestore = FirebaseFirestore.instance ;

  try{
    //load the json file from the assets
    String jsonString = await rootBundle.loadString('assets/categories.json');
    print("jsonString is $jsonString");
    print("---------");
    //parse the json
    Map<String, dynamic> parsedJson = jsonDecode(jsonString);
    List<dynamic> categories = parsedJson['categories'];

    print(categories.length);

    //loop through the categories and add them to the firestore
    for(var category in categories){
      //add a timestamp field
      category['timestamp'] = FieldValue.serverTimestamp();
      await firestore.collection("categories").doc(category['category_id']).set(category);
    }
    print("Categories uploaded successfully!");
  }catch(e){
    print(e.toString());
  }
}