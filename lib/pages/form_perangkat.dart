// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart'; // Import package for date formatting
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:servicedesknew/api.dart';

class FormPerangkat extends StatefulWidget {
  final Map<String, dynamic>? perangkat;
  const FormPerangkat({Key? key, this.perangkat}) : super(key: key);

  @override
  _FormPerangkatState createState() => _FormPerangkatState();
}

class _FormPerangkatState extends State<FormPerangkat> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaPerangkatController =
      TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _produkIdController = TextEditingController();

  // Daftar template nama perangkat
  final List<String> _templateNamaPerangkat = ['SOLNB24-SIT', 'SOLPC24-SIT'];

  @override
  void initState() {
    super.initState();
    if (widget.perangkat != null) {
      _namaPerangkatController.text = widget.perangkat!['nama_perangkat'];
      _serialNumberController.text = widget.perangkat!['serialnumber'];
      _produkIdController.text = widget.perangkat!['produkid'];
    }
  }

  Future<void> scanBarcode() async {
    try {
      String? barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);

      if (barcodeScanRes != '-1') {
        List<String> barcodeValues = barcodeScanRes.split(',');
        setState(() {
          if (barcodeValues.length >= 2) {
            _serialNumberController.text = barcodeValues[0];
            _produkIdController.text = barcodeValues[1];
          } else {
            _serialNumberController.text = barcodeScanRes;
          }
        });
      }
    } catch (e) {
      // Handle exception
      print('Error scanning barcode: $e');
    }
  }

  Future<void> saveData() async {
    final url =
        widget.perangkat == null ? Api.registerperangkat : Api.editperangkat;
    try {
      final response = await http.post(Uri.parse(url), body: {
        'id': widget.perangkat?['id'] ?? '',
        'nama_perangkat': _namaPerangkatController.text,
        'serialnumber': _serialNumberController.text,
        'produkid': _produkIdController.text,
        'created_at': DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
      });

      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body);
        if (dataJson['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Perangkat berhasil ${widget.perangkat == null ? 'ditambahkan' : 'diperbarui'}'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          String errorMessage = dataJson['message'];
          throw ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to save Data: $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        throw ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save Data: ${response.reasonPhrase}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      // Handle SocketException
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to connect to server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.perangkat == null ? 'Tambah Perangkat' : 'Edit Perangkat'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<String>.empty();
                  } else {
                    return _templateNamaPerangkat.where((String option) {
                      return option
                          .contains(textEditingValue.text.toUpperCase());
                    });
                  }
                },
                onSelected: (String selection) {
                  _namaPerangkatController.text = selection;
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration:
                        const InputDecoration(labelText: 'Nama Perangkat'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter device name';
                      }
                      return null;
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _serialNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Serial Number'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter serial number';
                        }
                        return null;
                      },
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.qr_code_scanner),
                    onPressed: scanBarcode,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _produkIdController,
                decoration: const InputDecoration(labelText: 'Product ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter product ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                child: Text(
                  widget.perangkat == null ? 'Tambah' : 'Update',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
