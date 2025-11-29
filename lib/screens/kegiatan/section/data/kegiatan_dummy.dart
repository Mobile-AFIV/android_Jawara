class KegiatanModel {
  final String namaKegiatan;
  final String kategori;
  final String deskripsi;
  final String tanggal;
  final String lokasi;
  final String penanggungJawab;
  final String dibuatOleh;

  /// List URL gambar dokumentasi
  final List<String> dokumentasi;

  KegiatanModel({
    required this.namaKegiatan,
    required this.kategori,
    required this.deskripsi,
    required this.tanggal,
    required this.lokasi,
    required this.penanggungJawab,
    required this.dibuatOleh,
    this.dokumentasi = const [],
  });
}

class KegiatanDummy {
  /// Opsi kategori kegiatan (dropdown)
  static final List<String> kategoriOptions = [
    "Sosial",
    "Pendidikan",
    "Keagamaan",
    "Lingkungan",
    "Kesehatan",
    "Olahraga",
    "Pelatihan",
    "Rapat",
    "Lainnya",
  ];

  /// Dummy data kegiatan
  static List<KegiatanModel> dummyKegiatan = [
    KegiatanModel(
      namaKegiatan: "Kerja Bakti Bersih Lingkungan",
      kategori: "Lingkungan",
      deskripsi:
          "Membersihkan area sekitar RT termasuk selokan, taman, dan jalan umum.",
      tanggal: "12 Oktober 2025",
      lokasi: "Area RT 05 RW 03",
      penanggungJawab: "Budi Santoso",
      dibuatOleh: "Ketua RT",
      dokumentasi: [
        "https://example.com/dokumentasi/kerjabakti1.jpg",
        "https://example.com/dokumentasi/kerjabakti2.jpg",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Pengajian Rutin Bulanan",
      kategori: "Keagamaan",
      deskripsi:
          "Pengajian rutin bersama warga untuk meningkatkan wawasan spiritual.",
      tanggal: "05 Oktober 2025",
      lokasi: "Musholla Al-Ikhlas",
      penanggungJawab: "Ahmad Fauzi",
      dibuatOleh: "Seksi Keagamaan",
      dokumentasi: [
        "https://example.com/dokumentasi/pengajian1.jpg",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Senam Pagi Mingguan",
      kategori: "Olahraga",
      deskripsi:
          "Senam pagi setiap minggu untuk meningkatkan kesehatan warga.",
      tanggal: "28 September 2025",
      lokasi: "Lapangan RT 05",
      penanggungJawab: "Dewi Lestari",
      dibuatOleh: "Seksi Kesehatan",
      dokumentasi: [
        "https://example.com/dokumentasi/senam1.jpg",
        "https://example.com/dokumentasi/senam2.jpg",
        "https://example.com/dokumentasi/senam3.jpg",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Pelatihan Pemanfaatan Limbah Rumah Tangga",
      kategori: "Pendidikan",
      deskripsi:
          "Pelatihan membuat kerajinan dari limbah rumah tangga seperti botol dan plastik.",
      tanggal: "20 November 2025",
      lokasi: "Balai Warga RT 05",
      penanggungJawab: "Rina Wijaya",
      dibuatOleh: "Seksi Pendidikan",
      dokumentasi: [
        "https://example.com/dokumentasi/pelatihan1.jpg",
      ],
    ),
    KegiatanModel(
      namaKegiatan: "Rapat Koordinasi Persiapan HUT RI",
      kategori: "Rapat",
      deskripsi:
          "Rapat untuk membahas persiapan kegiatan perayaan Hari Kemerdekaan RI.",
      tanggal: "01 Agustus 2025",
      lokasi: "Rumah Ketua RT",
      penanggungJawab: "Dimas Prasetyo",
      dibuatOleh: "Panitia HUT RI",
      dokumentasi: [],
    ),
  ];

  static void addKegiatan(KegiatanModel newKegiatan) {}
}
