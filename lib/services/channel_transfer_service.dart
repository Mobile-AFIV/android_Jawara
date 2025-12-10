import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/channel_transfer.dart';

class ChannelTransferService {
  // Singleton
  ChannelTransferService._();

  static final ChannelTransferService instance = ChannelTransferService._();

  final _db = FirebaseFirestore.instance;
  final _collection = "channel_transfer";

  Future<String> createChannelTransfer({
    required String nama,
    required String tipe,
    required String pemilik,
    required String nomorRekening,
  }) async {
    final docRef = _db.collection(_collection).doc();
    final data = {
      "nama": nama,
      "tipe": tipe,
      "pemilik": pemilik,
      "no_rek": nomorRekening,
      "createdAt": FieldValue.serverTimestamp(),
      "updatedAt": FieldValue.serverTimestamp(),
    };
    await docRef.set(data);
    return docRef.id;
  }

  Future<List<ChannelTransfer>> getAllChannelTransfers() async {
    QuerySnapshot channelSnapshot =
        await _db.collection("channel_transfer").get();

    List<ChannelTransfer> channels = channelSnapshot.docs.map(
      (data) {
        return ChannelTransfer.fromFirestore(data);
      },
    ).toList();

    return channels;
  }

  Future<void> updateChannelTransfer({
    required String id,
    required Map<String, dynamic> channelBaru,
  }) async {
    final Map<String, dynamic> data = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...channelBaru,
    };

    await _db.collection(_collection).doc(id).update(data);
  }

  Future<void> deleteChannelTransfer(String id) async {
    await _db.collection(_collection).doc(id).delete();
  }
}