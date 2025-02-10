
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

Future<void> addProductsToFirebase() async{

  //instance of firebase firestore
  final FirebaseFirestore firestore = FirebaseFirestore.instance;


  try{
    //load the json file from assets
    String jsonString = await rootBundle.loadString("assets/products.json");

    Map<String, dynamic> parsedJson = jsonDecode(jsonString);
    List<dynamic> products = parsedJson["products"];

    for(var productCategory in products){
      String categoryId = productCategory["category_id"];
      List<dynamic> vegProducts = productCategory["veg_products"];
      List<dynamic> nonVegProducts = productCategory["non_veg_products"];

      for(var product in vegProducts){
        product["category_id"] = categoryId ;
        product["image_url"] = <String>[];
        product["created_at"] = FieldValue.serverTimestamp();
        product["updated_at"] = FieldValue.serverTimestamp();

        //save the products without product id
        var docRef =  await firestore.collection("products").add(product);
        //update the product id now
        await firestore.collection("products").doc(docRef.id).update({"product_id": docRef.id,});

      }
      for(var product in nonVegProducts){
        product["category_id"] = categoryId ;
        product["image_url"] = <String>[];
        product["created_at"] = FieldValue.serverTimestamp();
        product["updated_at"] = FieldValue.serverTimestamp();

        //save the products without product id
       var docRef =  await firestore.collection("products").add(product);
       //update the product id now
        await firestore.collection("products").doc(docRef.id).update({"product_id": docRef.id,});
      }
    }
     print("product added to firebase");
  }catch(e){
    print(e.toString());
  }

}