import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/broadcast.dart';

class BroadcastService {
  // Singleton
  static final BroadcastService instance = BroadcastService._();
  BroadcastService._();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ---------------------------
  // UPLOAD GAMBAR KE STORAGE
  // ---------------------------
  Future<String> uploadImage(File file) async {
    try {
      String fileName = "images/${DateTime.now().millisecondsSinceEpoch}.jpg";
      UploadTask task = _storage.ref(fileName).putFile(file);
      TaskSnapshot snap = await task;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------
  // UPLOAD PDF KE STORAGE
  // ---------------------------
  Future<String> uploadPdf(File file) async {
    try {
      String fileName = "pdf/${DateTime.now().millisecondsSinceEpoch}.pdf";
      UploadTask task = _storage.ref(fileName).putFile(file);
      TaskSnapshot snap = await task;
      String downloadUrl = await snap.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------
  // TAMBAH DATA BROADCAST KE FIRESTORE
  // ---------------------------
  Future<void> addBroadcast(BroadcastModel model) async {
    try {
      await _firestore.collection("broadcasts").add(model.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------
  // UPDATE BROADCAST
  // ---------------------------
  Future<void> updateBroadcast(String id, Map<String, dynamic> data) async {
    try {
      await _firestore.collection("broadcasts").doc(id).update(data);
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------
  // DELETE BROADCAST
  // ---------------------------
  Future<void> deleteBroadcast(String id) async {
    try {
      await _firestore.collection("broadcasts").doc(id).delete();
    } catch (e) {
      rethrow;
    }
  }

  // ---------------------------
  // GET STREAM BROADCAST
  // ---------------------------
  Stream<List<BroadcastModel>> getAllBroadcasts() {
    return _firestore
        .collection("broadcasts")
        .orderBy("tanggal", descending: true)
        .snapshots()
        .map((snapshot) =>
            snapshot.docs.map((doc) => BroadcastModel.fromFirestore(doc)).toList());
  }

  // ---------------------------
  // GET SINGLE BROADCAST BY ID
  // ---------------------------
  Future<BroadcastModel?> getBroadcastById(String id) async {
    try {
      final doc = await _firestore.collection("broadcasts").doc(id).get();
      if (doc.exists) {
        return BroadcastModel.fromFirestore(doc);
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }
}
