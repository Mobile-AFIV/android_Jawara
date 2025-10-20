import 'package:flutter/material.dart';

class BroadcastDetail extends StatefulWidget {
  const BroadcastDetail({super.key});

  @override
  State<BroadcastDetail> createState() => _BroadcastDetailState();
}

class _BroadcastDetailState extends State<BroadcastDetail> {
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
                    'Nama Broadcast: Rapat RT 05',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Isi Broadcast:\nblabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla blabla',
                    style: TextStyle(fontSize: 16),
                  ),
                   SizedBox(height: 8),
                  Text(
                    'Tanggal Publikasi:\n17 agustus 1945',
                    style: TextStyle(fontSize: 16),
                  ),
                   SizedBox(height: 8),
                  Text(
                    'Dibuat Oleh: \nPak RT',
                    style: TextStyle(fontSize: 16),
                  ),
                   SizedBox(height: 8),
                  Text(
                    'Lampiran gambar:',
                    style: TextStyle(fontSize: 16),
                  ),
                  Card(
                    margin: EdgeInsets.only(top: 8.0),
                    child: Image(
                      image: AssetImage('assets/images/placeholder.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(
                    'Lampira PDF:',
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