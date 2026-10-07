import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Pembuatan Variabel Yang Akan Dipakai
  TextEditingController inputNama = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nama App Kalian"),
        backgroundColor: Color.fromRGBO(0, 50, 145, 145),
      ),
      //Color.fromRGBO( opacity, red, gren, blue)
      backgroundColor: Color.fromARGB(206, 46, 140, 218),
      body: Column(
        children: [
          Center(
            child: Container(
              width: 300,
              // height: 300,
              color: Color.fromRGBO(182, 218, 115, 1),
              child: TextField(
                // Dekorasi untuk Petunjuk Pengisian dan Garis
                decoration: InputDecoration(
                  hintText: 'Masukan Nama Kamu',
                  border: OutlineInputBorder(),
                ),
                // kontroller untuk
                controller: inputNama,
                // Ketika Dikirim nanti
                onSubmitted: (values) {
                  // isi blabla
                  inputNama.text = values;
                },
              ),
            ),
          ),
          ElevatedButton(
            child: Text("Tampilkan Nama"),
            onPressed: () {
              print(inputNama.text);
            },
          ),
        ],
      ),
    );
  }
}