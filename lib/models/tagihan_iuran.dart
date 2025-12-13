import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusPembayaran {
  belum('Belum Dibayar'),
  menunggu('Menunggu Persetujuan'),
  diterima('Diterima'),
  ditolak('Ditolak');

  final String label;
  const StatusPembayaran(this.label);
}

enum StatusKeluargaTagihan {
  aktif('Aktif'),
  nonaktif('Nonaktif');

  final String label;
  const StatusKeluargaTagihan(this.label);
}

class TagihanIuran {
  final String id;
  final String idKeluarga;
  final String namaKeluarga;
  final String alamat;
  final String kategoriIuran; // dari kategori_iuran
  final String idKategoriIuran;
  final int nominal;
  final DateTime periode; // bulan & tahun
  final StatusPembayaran statusPembayaran;
  final StatusKeluargaTagihan statusKeluarga;
  final String? metodePembayaran;
  final DateTime createdAt;
  final DateTime? updatedAt;

  TagihanIuran({
    required this.id,
    required this.idKeluarga,
    required this.namaKeluarga,
    required this.alamat,
    required this.kategoriIuran,
    required this.idKategoriIuran,
    required this.nominal,
    required this.periode,
    required this.statusPembayaran,
    required this.statusKeluarga,
    this.metodePembayaran,
    required this.createdAt,
    this.updatedAt,
  });

  factory TagihanIuran.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return TagihanIuran(
      id: doc.id,
      idKeluarga: data['id_keluarga'] ?? '',
      namaKeluarga: data['nama_keluarga'] ?? '',
      alamat: data['alamat'] ?? '',
      kategoriIuran: data['kategori_iuran'] ?? '',
      idKategoriIuran: data['id_kategori_iuran'] ?? '',
      nominal: data['nominal'] ?? 0,
      periode: (data['periode'] as Timestamp).toDate(),
      statusPembayaran: _parseStatusPembayaran(data['status_pembayaran']),
      statusKeluarga: _parseStatusKeluarga(data['status_keluarga']),
      metodePembayaran: data['metode_pembayaran'],
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      updatedAt: data['updatedAt'] != null
          ? (data['updatedAt'] as Timestamp).toDate()
          : null,
    );
  }

  static StatusPembayaran _parseStatusPembayaran(String? status) {
    switch (status) {
      case 'menunggu':
        return StatusPembayaran.menunggu;
      case 'diterima':
        return StatusPembayaran.diterima;
      case 'ditolak':
        return StatusPembayaran.ditolak;
      default:
        return StatusPembayaran.belum;
    }
  }

  static StatusKeluargaTagihan _parseStatusKeluarga(String? status) {
    switch (status) {
      case 'nonaktif':
        return StatusKeluargaTagihan.nonaktif;
      default:
        return StatusKeluargaTagihan.aktif;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id_keluarga': idKeluarga,
      'nama_keluarga': namaKeluarga,
      'alamat': alamat,
      'kategori_iuran': kategoriIuran,
      'id_kategori_iuran': idKategoriIuran,
      'nominal': nominal,
      'periode': Timestamp.fromDate(periode),
      'status_pembayaran': statusPembayaran.name,
      'status_keluarga': statusKeluarga.name,
      'metode_pembayaran': metodePembayaran,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
  }
}

// Model untuk Riwayat Pembayaran
class RiwayatPembayaran {
  final String id;
  final String idTagihan;
  final StatusPembayaran status;
  final String? buktiUrl;
  final String? catatan;
  final DateTime tanggal;
  final String? verifikator;

  RiwayatPembayaran({
    required this.id,
    required this.idTagihan,
    required this.status,
    this.buktiUrl,
    this.catatan,
    required this.tanggal,
    this.verifikator,
  });

  factory RiwayatPembayaran.fromFirestore(DocumentSnapshot doc) {
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

    return RiwayatPembayaran(
      id: doc.id,
      idTagihan: data['id_tagihan'] ?? '',
      status: _parseStatus(data['status']),
      buktiUrl: data['bukti_url'],
      catatan: data['catatan'],
      tanggal: (data['tanggal'] as Timestamp).toDate(),
      verifikator: data['verifikator'],
    );
  }

  static StatusPembayaran _parseStatus(String? status) {
    switch (status) {
      case 'menunggu':
        return StatusPembayaran.menunggu;
      case 'diterima':
        return StatusPembayaran.diterima;
      case 'ditolak':
        return StatusPembayaran.ditolak;
      default:
        return StatusPembayaran.belum;
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id_tagihan': idTagihan,
      'status': status.name,
      'bukti_url': buktiUrl,
      'catatan': catatan,
      'tanggal': Timestamp.fromDate(tanggal),
      'verifikator': verifikator,
    };
  }
}
