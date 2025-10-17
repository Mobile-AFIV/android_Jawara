class PemasukanSectionData {
  static final List<Map<String, dynamic>> kategoriIuranData = [
    {
      'no': 1,
      'nama': 'Bersih Desa',
      'jenis': jenisIuranList[0],
      'nominal': 200000,
    },
    {
      'no': 2,
      'nama': 'Mingguan',
      'jenis': jenisIuranList[1],
      'nominal': 12,
    },
    {
      'no': 3,
      'nama': 'Agustusan',
      'jenis': jenisIuranList[1],
      'nominal': 15,
    },
  ];

  static final List<String> jenisIuranList = ['Iuran Bulanan', 'Iuran Khusus'];
}