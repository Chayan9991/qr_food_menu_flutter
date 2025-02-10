import 'package:cloud_firestore/cloud_firestore.dart';

Future<void> fetchProductByCategoryId(String categoryId) async {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  try {
    QuerySnapshot querySnapshot = await firestore
        .collection("customization")
        .where("category_id", isEqualTo: categoryId)
        .get();

    // Extract the data from the query result
    List<QueryDocumentSnapshot> documents = querySnapshot.docs;

    // Print or process each product
    for (var doc in documents) {
      Map<String, dynamic> product = doc.data() as Map<String, dynamic>;
      print(product);
    }


  } catch (e) {
    print(e.toString());
  }
}
