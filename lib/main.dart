import 'package:flutter/material.dart';

void main() {
  runApp(CatatanKuApp());
}

class CatatanKuApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CatatanKu',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: CatatanKuHomePage(),
    );
  }
}

class CatatanKuHomePage extends StatefulWidget {
  @override
  _CatatanKuHomePageState createState() => _CatatanKuHomePageState();
}

class _CatatanKuHomePageState extends State<CatatanKuHomePage> {
  List<Catatan> catatanList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image.asset(
              "images/the-x.png",
              fit: BoxFit.contain,
            )),
        actions: [
          Image.asset(
            "images/fasilkom.jpg",
          )
        ],
        backgroundColor: Colors.blue,
        toolbarHeight: 75,
        centerTitle: true,
        title: Text(
          'CatatanKu',
          style: TextStyle(
              color: Colors.white, fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView.builder(
        itemCount: catatanList.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(catatanList[index].judul),
            onDismissed: (direction) {
              _hapusCatatan(index);
            },
            confirmDismiss: (direction) {
              return showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('PERINGATAN!!!'),
                    content:
                        Text('Apakah anda yakin ingin menghapus catatan ini?'),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(false);
                          },
                          child: Text('No')),
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop(true);
                          },
                          child: Text('Yes')),
                    ],
                  );
                },
              );
            },
            background: Container(
              color: Colors.red,
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 16.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            child: ListTile(
              title: Text(catatanList[index].judul),
              subtitle: Text(
                catatanList[index].isi,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                _tampilkanDetailCatatan(context, catatanList[index]);
              },

              // Tambahkan tombol edit pada setiap catatan
              trailing: IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  _editCatatan(context, catatanList[index]);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  TambahCatatanPage(onTambahCatatan: _tambahCatatan),
            ),
          );
        },
        tooltip: 'Buat Catatan Baru',
        child: Icon(Icons.add),
      ),
    );
  }

  void _editCatatan(BuildContext context, Catatan catatan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EditCatatanPage(
          catatan: catatan,
          onSimpanPerubahan: (Catatan catatanBaru) {
            _simpanPerubahanCatatan(catatan, catatanBaru);
          },
        ),
      ),
    );
  }

  void _simpanPerubahanCatatan(Catatan catatanLama, Catatan catatanBaru) {
    setState(() {
      int index = catatanList.indexOf(catatanLama);
      catatanList[index] = catatanBaru;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catatan diperbarui'),
      ),
    );
  }

  void _hapusCatatan(int index) {
    setState(() {
      catatanList.removeAt(index);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Catatan dihapus'),
      ),
    );
  }

  void _tambahCatatan(Catatan catatan) {
    setState(() {
      catatanList.add(catatan);
    });
  }

  void _tampilkanDetailCatatan(BuildContext context, Catatan catatan) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailCatatanPage(catatan: catatan),
      ),
    );
  }
}

class EditCatatanPage extends StatelessWidget {
  final Catatan catatan;
  final Function(Catatan) onSimpanPerubahan;

  EditCatatanPage({required this.catatan, required this.onSimpanPerubahan});

  @override
  Widget build(BuildContext context) {
    TextEditingController judulController =
        TextEditingController(text: catatan.judul);
    TextEditingController isiController =
        TextEditingController(text: catatan.isi);

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Catatan'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: isiController,
              decoration: InputDecoration(labelText: 'Isi Catatan'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Catatan catatanBaru = Catatan(
                  judul: judulController.text,
                  isi: isiController.text,
                );
                onSimpanPerubahan(catatanBaru);
                Navigator.pop(context);
              },
              child: Text('Simpan Perubahan'),
            ),
          ],
        ),
      ),
    );
  }
}

class Catatan {
  String judul;
  String isi;

  Catatan({
    required this.judul,
    required this.isi,
  });
}

class TambahCatatanPage extends StatelessWidget {
  final Function(Catatan) onTambahCatatan;

  TambahCatatanPage({required this.onTambahCatatan});

  @override
  Widget build(BuildContext context) {
    TextEditingController judulController = TextEditingController();
    TextEditingController isiController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tambah Catatan Baru'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: judulController,
              decoration: InputDecoration(labelText: 'Judul'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: isiController,
              decoration: InputDecoration(labelText: 'Isi Catatan'),
              maxLines: null,
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Catatan catatan = Catatan(
                  judul: judulController.text,
                  isi: isiController.text,
                );
                onTambahCatatan(catatan);
                Navigator.pop(context);
              },
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailCatatanPage extends StatelessWidget {
  final Catatan catatan;

  DetailCatatanPage({required this.catatan});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        toolbarHeight: 75,
        centerTitle: true,
        title: Text(
          catatan.judul,
          style: TextStyle(
              color: Colors.white, fontSize: 25, fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Isi Catatan:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(catatan.isi),
          ],
        ),
      ),
    );
  }
}
