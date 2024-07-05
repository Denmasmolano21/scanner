// ignore_for_file: use_build_context_synchronously, library_private_types_in_public_api

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:servicedesknew/api.dart';
import 'package:servicedesknew/pages/form_perangkat.dart';

class DataPerangkat extends StatefulWidget {
  const DataPerangkat({Key? key}) : super(key: key);

  @override
  _DataPerangkatState createState() => _DataPerangkatState();
}

class _DataPerangkatState extends State<DataPerangkat> {
  late Future<List<Map<String, dynamic>>> _fetchDataFuture;
  List<Map<String, dynamic>> _dataPerangkat = [];
  List<Map<String, dynamic>> _filteredDataPerangkat = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDataFuture = fetchData();
    _searchController.addListener(_filterData);
  }

  Future<List<Map<String, dynamic>>> fetchData() async {
    final response = await http.get(Uri.parse(Api.readperangkat));
    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      setState(() {
        _dataPerangkat = List<Map<String, dynamic>>.from(data);
        _filteredDataPerangkat = _dataPerangkat;
      });
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to load Data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredDataPerangkat = _dataPerangkat.where((item) {
        final namaPerangkat = item['nama_perangkat'].toString().toLowerCase();
        final serialNumber = item['serialnumber'].toString().toLowerCase();
        final produkId = item['produkid'].toString().toLowerCase();
        final createdAt = item['created_at'].toString().toLowerCase();
        return namaPerangkat.contains(query) ||
            serialNumber.contains(query) ||
            produkId.contains(query) ||
            createdAt.contains(query);
      }).toList();
    });
  }

  Future<void> refreshData() async {
    setState(() {
      _fetchDataFuture = fetchData(); // Refresh data
    });
  }

  Future<void> deletePerangkat(String id) async {
    final response =
        await http.post(Uri.parse(Api.deleteperangkat), body: {'id': id});
    if (response.statusCode == 200) {
      final dataJson = jsonDecode(response.body);
      if (dataJson['status'] == 1) {
        refreshData(); // Refresh data after delete
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Perangkat berhasil dihapus'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
          throw ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to delete Data'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } else {
      throw ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete Data'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void showDetailDialog(Map<String, dynamic> perangkat) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: contentBox(context, perangkat),
        );
      },
    );
  }

  Widget contentBox(BuildContext context, Map<String, dynamic> perangkat) {
    return Stack(
      children: <Widget>[
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                perangkat['nama_perangkat'],
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Serial Number: ${perangkat['serialnumber']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 10),
              Text(
                'Product ID: ${perangkat['produkid']}',
                style: const TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              Text(
                'Data Masuk Pada Tanggal: ${perangkat['created_at']}',
                style: const TextStyle(fontSize: 16),
              ),
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
                              FormPerangkat(perangkat: perangkat),
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
                                'Apakah Anda yakin ingin menghapus perangkat ini?'),
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
                        deletePerangkat(perangkat['id'].toString());
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('List Perangkat'),
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
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 10), // Added this line
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
            MaterialPageRoute(builder: (context) => const FormPerangkat()),
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
              List<Map<String, dynamic>> perangkat = _filteredDataPerangkat;
              if (perangkat.isEmpty) {
                return const Center(child: Text('Tidak ada data'));
              } else {
                return ListView.builder(
                  itemCount: perangkat.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        showDetailDialog(perangkat[index]);
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
                                    '${perangkat[index]['nama_perangkat']}',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Serial Number: ${perangkat[index]['serialnumber']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              Text(
                                'Produk ID: ${perangkat[index]['produkid']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                              const SizedBox(height: 20),
                              Text(
                                'Data Masuk Pada Tanggal: ${perangkat[index]['created_at']}',
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
