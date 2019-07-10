import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

typedef Query QueryFunction(CollectionReference ref);

class FirestoreService {
  Future<DocumentReference> addDoc(String col, Map<String, dynamic> doc) {
    return Firestore.instance.collection(col).add(doc);
  }

  Future<void> setDoc(String docRef, Map<String, dynamic> doc) {
    return Firestore.instance.document(docRef).setData(doc);
  }

  Future<void> updateDoc(String docRef, Map<String, dynamic> doc) {
    return Firestore.instance.document(docRef).updateData(doc);
  }

  Stream<List<Map<String, dynamic>>> $colWithIds(
    String colRef,
    QueryFunction queryFn
  ) {
    StreamController<List<Map<String, dynamic>>> streamController = new StreamController();
    
    if (queryFn != null) {
      queryFn(Firestore.instance.collection(colRef)).snapshots().listen((data) {
        List<Map<String, dynamic>> docs = [];

        data.documents.forEach((doc) {
          Map<String, dynamic> data = doc.data;
          data['id'] = doc.documentID;
          docs.add(data);
        });

        streamController.add(docs);
      });
    } else {
      Firestore.instance.collection(colRef).snapshots().listen((data) {
        List<Map<String, dynamic>> docs;

        data.documents.forEach((doc) {
          Map<String, dynamic> data = doc.data;
          data['id'] = doc.documentID;
          docs.add(data);
        });

        streamController.add(docs);
      });
    }

    return streamController.stream;
  }
}
