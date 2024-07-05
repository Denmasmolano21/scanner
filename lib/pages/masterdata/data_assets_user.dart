// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicedesknew/api.dart';
import 'package:servicedesknew/pages/masterdata/form_assetsuser.dart';

class DataAssetsUser extends StatefulWidget {
  const DataAssetsUser({Key? key}) : super(key: key);

  @override
  _DataAssetsUserState createState() => _DataAssetsUserState();
}

class _DataAssetsUserState extends State<DataAssetsUser> {
  late Future<List<Map<String, dynamic>>> _fetchDataFuture;
  List<Map<String, dynamic>> _dataAssetsUser = [];
  List<Map<String, dynamic>> _filteredDataAssetsUser = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData();
    _searchController.addListener(_filterData);
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(Api.readassetsuser));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _dataAssetsUser = List<Map<String, dynamic>>.from(data);
        _filteredDataAssetsUser = _dataAssetsUser;
      });
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to load data'),
            backgroundColor: Colors.red,
          ),
        );
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDataAssetsUser = _dataAssetsUser.where((item) {
        final namaPengguna = item['NamaPengguna'].toString().toLowerCase();
        final serialNumber = item['SerialNumber'].toString().toLowerCase();
        final penyedia = item['Penyedia'].toString().toLowerCase();
        final tahun = item['Tahun'].toString().toLowerCase();
        return namaPengguna.contains(query) ||
            serialNumber.contains(query) ||
            penyedia.contains(query) ||
            tahun.contains(query);
      }).toList();
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _fetchDataFuture = fetchData(); // Refresh data
    });
  }

  Future<void> deleteassetuser(String id) async {
    final response =
        await http.post(Uri.parse(Api.deleteassetuser), body: {'id': id});
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      if (dataJson['status'] == 1) {
        refreshData(); // Refresh data after delete
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Asset berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed To delete Data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed To Delete Data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showDetailDialog(Map<String, dynamic> asset) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, asset),
        );
      },
    );
  }

  Widget contentBox(BuildContext context, Map<String, dynamic> asset) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                offset: Offset(0, 4),
                blurRadius: 10,
              ),
            ],
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Text(
                    asset['NamaPengguna'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                detailRow('Serial Number', asset['SerialNumber']),
                detailRow('Penyedia', asset['Penyedia']),
                detailRow('Tahun', asset['Tahun']),
                detailRow('NIP', asset['Nip']),
                detailRow('Satuan Kerja', asset['SatuanKerja']),
                detailRow('Area', asset['Area']),
                detailRow('Status Pekerja', asset['StatusPekerja']),
                detailRow('Email', asset['Email']),
                detailRow('Status Laptop', asset['StatusLaptop']),
                detailRow('Kondisi Sewa', asset['KondisiSewa']),
                detailRow('Type', asset['Type']),
                detailRow('Periode Laptop', asset['PeriodeLaptop']),
                detailRow('Spesifikasi', asset['Spesifikasi']),
                detailRow('Nama Komputer', asset['NamaKomputer']),
                detailRow('No. BAST', asset['NoBAST']),
                detailRow('No. HBB', asset['NoHBB']),
                detailRow('Keterangan', asset['Keterangan']),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                FormAssetsUser(assetUser: asset),
                          ),
                        ).then((_) => refreshData());
                      },
                      child: const Text(
                        'Edit',
                        style: TextStyle(color: Colors.orange, fontSize: 16),
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        bool confirm = await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Konfirmasi'),
                              content: const Text(
                                  'Apakah Anda yakin ingin menghapus Asset ini?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Batal'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Hapus'),
                                ),
                              ],
                            );
                          },
                        );
                        if (confirm) {
                          deleteassetuser(asset['pID'].toString());
                        }
                      },
                      child: const Text(
                        'Delete',
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 10,
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: CircleAvatar(
              radius: 14,
              backgroundColor: Colors.grey.shade200,
              child: const Icon(Icons.close, color: Colors.black),
            ),
          ),
        ),
      ],
    );
  }

  Widget detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            flex: 7,
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Assets User'),
        actions: <Widget>[
          IconButton(
            onPressed: refreshData,
            icon: const Icon(Icons.refresh),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                prefixIcon: const Icon(Icons.search),
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FormAssetsUser()),
          ).then((_) => refreshData());
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: _fetchDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              List<Map<String, dynamic>> asset = _filteredDataAssetsUser;
              if (asset.isEmpty) {
                return const Center(child: Text('Tidak ada data'));
              } else {
                return RefreshIndicator(
                  onRefresh: refreshData,
                  child: ListView.builder(
                    itemCount: asset.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          showDetailDialog(asset[index]);
                        },
                        child: Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      '${asset[index]['NamaPengguna']}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Serial Number: ${asset[index]['SerialNumber']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                Text(
                                  'Penyedia: ${asset[index]['Penyedia']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Tahun: ${asset[index]['Tahun']}',
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                );
              }
            }
          },
        ),
      ),
    );
  }
}
