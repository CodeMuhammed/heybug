import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  Future<DocumentReference> addDoc(String col, Map<String, dynamic> doc) {
    return Firestore.instance
        .collection(col).add(doc);
  }

  Future<void> setDoc(String docRef, Map<String, dynamic> doc) {
    return Firestore.instance
        .document(docRef).setData(doc);
  }

  Future<void> updateDoc(String docRef, Map<String, dynamic> doc) {
    return Firestore.instance
        .document(docRef).updateData(doc);
  }
}
