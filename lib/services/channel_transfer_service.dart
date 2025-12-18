import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../models/channel_transfer.dart';
import 'log_aktivitas_service.dart';

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
    await LogAktivitasService.instance.createLogAktivitas(
      deskripsi: 'Menambahkan Channel baru : $pemilik',
      aktor: 'System',
    );
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
    final docRef = _db.collection(_collection).doc(id);

    final oldDoc = await docRef.get();
    final oldData = oldDoc.data() ?? {};

    final String namaChannel = channelBaru['nama'] ?? oldData['nama'] ?? 'Unknown';
    final String pemilikChannel = channelBaru['pemilik'] ?? oldData['pemilik'] ?? 'Unknown';

    final data = {
      "updatedAt": FieldValue.serverTimestamp(),
      ...channelBaru,
    };

    await docRef.update(data);
    await LogAktivitasService.instance.createLogAktivitas(
      deskripsi: 'Mengubah data channel: $namaChannel ($pemilikChannel) diperbarui',
      aktor: 'System',
    );
  }

  Future<void> deleteChannelTransfer(String id) async {
    final docRef = _db.collection(_collection).doc(id);

    final doc = await docRef.get();
    final data = doc.data() ?? {};
    final String namaChannel = data['nama'] ?? 'Unknown';
    final String pemilikChannel = data['pemilik'] ?? 'Unknown';

    await docRef.delete();
    await LogAktivitasService.instance.createLogAktivitas(
        deskripsi: 'Menghapus data channel: $namaChannel' '($pemilikChannel)',
        aktor: 'System',
      ); 
  }
}