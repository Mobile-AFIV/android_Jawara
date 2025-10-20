import 'package:flutter/material.dart';

class KegiatanDetail extends StatefulWidget {
  const KegiatanDetail({super.key});

  @override
  State<KegiatanDetail> createState() => _KegiatanDetailState();
}

class _KegiatanDetailState extends State<KegiatanDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Broadcast Detail"),
      ),
      body: Column( 
        children: [
          Card(
            margin: const EdgeInsets.all(16.0),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Nama Kegiatan: Rapat RT 05',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Kategori: \nKomunitas dan Sosial',
                    style: TextStyle(fontSize: 16),
                  ),
                   SizedBox(height: 8),
                  Text(
                    'Deskripsi Kegiatan:\nblabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla',
                    style: TextStyle(fontSize: 16),
                  ),
                   SizedBox(height: 8),
                  Text(
                    'Lokasi Kegiatan:\nBalai RW 05',
                    style: TextStyle(fontSize: 16),
                  ),
                   SizedBox(height: 8),
                  Text(
                    'Penanggung Jawab: \nPak RT',
                    style: TextStyle(fontSize: 16),
                  ),
                  
                  Text(
                    'Dibuat Oleh: \nPak RT',
                    style: TextStyle(fontSize: 16),
                  ),
                  Text(
                    'Dokumentasi',
                    style: TextStyle(fontSize: 16),
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Image(
                      image: AssetImage('assets/images/placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  
                ],
              ),
            ),
          ),
      ],)
    );
  }
}