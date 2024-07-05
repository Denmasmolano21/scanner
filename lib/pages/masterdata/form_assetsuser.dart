// ignore_for_file: avoid_print, use_build_context_synchronously

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:servicedesknew/api.dart';

class FormAssetsUser extends StatefulWidget {
  final Map<String, dynamic>? assetUser;

  const FormAssetsUser({Key? key, this.assetUser}) : super(key: key);

  @override
  _FormAssetsUserState createState() => _FormAssetsUserState();
}

class _FormAssetsUserState extends State<FormAssetsUser> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nipController = TextEditingController();
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _noHbbController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _noBastController = TextEditingController();
  final TextEditingController _spesifikasiController = TextEditingController();
  final TextEditingController _serialNumberController = TextEditingController();
  final TextEditingController _namaKomputerController = TextEditingController();
  final TextEditingController _keteranganController = TextEditingController();

  String? _selectedArea;
  String? _selectedType;
  String? _selectedPeriode;
  String? _selectedSatuanKerja;
  String? _selectedStatusPekerja;
  String? _selectedStatusLaptop;
  String? _selectedKondisiSewa;
  String? _selectedPenyedia;
  String? _selectedTahun;

  final List<String> tahunList = [
    '2019',
    '2020',
    '2021',
    '2022',
    '2023',
    '2024',
    '2025',
    '2026',
    '2027',
    '2028',
    '2029',
    '2030',
  ];
  final List<String> typeList = [
    'PC',
    'Notebook',
  ];
  final List<String> penyediaList = [
    'BERCA',
    'PGAS COM',
    'BHINEKA',
  ];
  final List<String> areaList = [
    'PGAS Solution Area Kantor Pusat',
    'PGAS Solution Area Bogor',
    'PGAS Solution Area Bekasi',
    'PGAS Solution Area Karawang',
    'PGAS Solution Area Cirebon',
    'PGAS Solution Area Serpong',
    'PGAS Solution Area Cilegon',
    'PGAS Solution Area Surabaya',
    'PGAS Solution Area Pasuruan',
    'PGAS Solution Area Sidoarjo',
    'PGAS Solution Area Semarang',
    'PGAS Solution Area Tarakan',
    'PGAS Solution Area Sorong',
    'PGAS Solution Area Lampung',
    'PGAS Solution Area Sumatera Selatan',
    'PGAS Solution Area Medan',
    'PGAS Solution Area Batam',
    'PGAS Solution Area Riau',
    'PGAS Solution Area Palembang',
    'PGAS Solution KORPEL Daan Mogot',
    'PGAS Solution Area Klender',
    'PGAS Solution Area Dumai',
    'PGAS Solution Area Tangerang',
    'PGAS Solution Area Jakarta (Daan Mogot)',
    'PGAS Solution Area Gresik',
  ];
  final List<String> periodeList = [
    'WO I',
    'WO II',
    'WO III',
    'WO IV',
    'WO V',
    'WO VI',
    'WO VII',
    'WO VIII',
    'WO IX',
    'WO X',
  ];
  final List<String> satuanKerjaList = [
    'Anggaran & Akuntansi',
    'Direktur Keuangan & Dukungan Bisnis',
    'Direktur Operasi',
    'Direktur Teknik & Pengembangan',
    'Direktur Utama',
    'Enjiniring EPC',
    'Enjiniring Operasi',
    'Hukum & GCG',
    'Humas',
    'Informasi, Komunikasi & Teknologi',
    'Integrity & QA',
    'IT Product Development',
    'IT Service Management',
    'K3 & Pengamanan',
    'K3PL & Pengamanan',
    'Kalibrasi Instrumentasi',
    'Kalibrasi, Instrumentasi dan Manufaktur',
    'Kalibrasi Manufaktur Pergudangan',
    'Keuangan',
    'Komersial',
    'Koordinator Pelaksana Proyek EPC',
    'Layanan & Operasional K3PL',
    'Layanan Pendukung Proyek',
    'Logistik & Administrasi',
    'Manajemen Informasi',
    'Manajemen Mutu & QA',
    'Manajemen Proyek EPC',
    'Manajemen Proyek Operasi',
    'Manajemen Risiko',
    'Manajemen Solusi Bisnis',
    'Manajemen Training dan Keahlian',
    'Manufaktur & Repair',
    'Pelaksana Proyek Operasi',
    'Pemasaran',
    'Pengadaan dan Manajemen Penyedia',
    'Pengawas Internal',
    'Pengawas Kerja',
    'Pengelolaan Lingkungan',
    'Pengembangan Bisnis & Manajemen Risiko',
    'Pengembangan Organisasi dan SDM',
    'Pengendali Kontrak Claim Manajemen',
    'Pengendali Proyek',
    'Penjualan & Layanan',
    'Perbendaharaan & TJSL',
    'Perencanaan Strategis & Pengembangan Bisnis',
    'Perpajakan',
    'Persediaan dan Layanan Umum',
    'Satuan Pengawas Internal',
    'Sekretaris Perusahaan',
    'Sistem Informasi Teknologi',
    'Sumber Daya Manusia'
  ];

  final List<String> kondisiSewaList = [
    'Sewa Berjalan',
    'Sudah Dikembalikan',
    'Sudah Habis Sewa',
    'PC/Notebook Hilang',
  ];
  final List<String> statusLaptopList = [
    'Sewa Murni',
    'Sewa Milik (Operasional)',
    'Investasi',
  ];
  final List<String> statusPekerjaList = [
    'Organik',
    'TAD',
  ];

  @override
  void initState() {
    super.initState();
    if (widget.assetUser != null) {
      _namaController.text = widget.assetUser!['NamaPengguna'];
      _nipController.text = widget.assetUser!['Nip'];
      _noHbbController.text = widget.assetUser!['NoHBB'];
      _emailController.text = widget.assetUser!['Email'];
      _noBastController.text = widget.assetUser!['NoBAST'];
      _spesifikasiController.text = widget.assetUser!['Spesifikasi'];
      _serialNumberController.text = widget.assetUser!['SerialNumber'];
      _namaKomputerController.text = widget.assetUser!['NamaKomputer'];
      _keteranganController.text = widget.assetUser!['Keterangan'];
      _selectedArea = widget.assetUser!['Area'];
      _selectedType = widget.assetUser!['Type'];
      _selectedPeriode = widget.assetUser!['PeriodeLaptop'];
      _selectedSatuanKerja = widget.assetUser!['SatuanKerja'];
      _selectedStatusPekerja = widget.assetUser!['StatusPekerja'];
      _selectedStatusLaptop = widget.assetUser!['StatusLaptop'];
      _selectedKondisiSewa = widget.assetUser!['KondisiSewa'];
      _selectedPenyedia = widget.assetUser!['Penyedia'];
      _selectedTahun = widget.assetUser!['Tahun'];
    } else {
      _spesifikasiController.text =
          'Thinkpad L13 | Intel Core i5-10210U | 8GB RAM | 256GB SSD | Windows 10 Pro';
    }
  }

  Future<void> saveData() async {
    final url =
        widget.assetUser == null ? Api.registerassetuser : Api.editassetuser;
    try {
      final response = await http.post(
        Uri.parse(url),
        body: {
          'pID': widget.assetUser?['pID'] ?? '',
          'NamaPengguna': _namaController.text,
          'Nip': _nipController.text,
          'SatuanKerja': _selectedSatuanKerja,
          'Area': _selectedArea,
          'StatusPekerja': _selectedStatusPekerja,
          'Email': _emailController.text,
          'StatusLaptop': _selectedStatusLaptop,
          'KondisiSewa': _selectedKondisiSewa,
          'Type': _selectedType,
          'PeriodeLaptop': _selectedPeriode,
          'Spesifikasi': _spesifikasiController.text,
          'SerialNumber': _serialNumberController.text,
          'NamaKomputer': _namaKomputerController.text,
          'NoBAST': _noBastController.text,
          'NoHBB': _noHbbController.text,
          'Penyedia': _selectedPenyedia,
          'Keterangan': _keteranganController.text,
          'Tahun': _selectedTahun,
          'created_at':
              DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now()),
        },
      );

      if (response.statusCode == 200) {
        final dataJson = jsonDecode(response.body);
        if (dataJson['status'] == 1) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  'Data assets user berhasil ${widget.assetUser == null ? 'ditambahkan' : 'diperbarui'}'),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.of(context).pop();
        } else {
          throw Exception('Failed to save data: ${dataJson['message']}');
        }
      } else {
        throw Exception('Failed to save data: ${response.reasonPhrase}');
      }
    } catch (e) {
      if (!mounted) return; // Check if the widget is still mounted
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to connect to server'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _namaController.dispose();
    _nipController.dispose();
    _emailController.dispose();
    _spesifikasiController.dispose();
    _serialNumberController.dispose();
    _namaKomputerController.dispose();
    _noBastController.dispose();
    _noHbbController.dispose();
    _keteranganController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.assetUser == null
            ? 'Tambah Data Assets User'
            : 'Edit Data Assets User'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _namaController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nipController,
                decoration: const InputDecoration(labelText: 'NIP'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'NIP tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Satuan Kerja'),
                value: _selectedSatuanKerja,
                items: satuanKerjaList
                    .map((satuanKerja) => DropdownMenuItem(
                          value: satuanKerja,
                          child: Text(satuanKerja),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSatuanKerja = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih satuan kerja' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Area'),
                value: _selectedArea,
                items: areaList
                    .map((area) => DropdownMenuItem(
                          value: area,
                          child: Text(area),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedArea = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih area' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status Pekerja'),
                value: _selectedStatusPekerja,
                items: statusPekerjaList
                    .map((statusPekerja) => DropdownMenuItem(
                          value: statusPekerja,
                          child: Text(statusPekerja),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatusPekerja = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih status pekerja' : null,
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Status Laptop'),
                value: _selectedStatusLaptop,
                items: statusLaptopList
                    .map((statusLaptop) => DropdownMenuItem(
                          value: statusLaptop,
                          child: Text(statusLaptop),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedStatusLaptop = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih status laptop' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Kondisi Sewa'),
                value: _selectedKondisiSewa,
                items: kondisiSewaList
                    .map((kondisiSewa) => DropdownMenuItem(
                          value: kondisiSewa,
                          child: Text(kondisiSewa),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedKondisiSewa = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih kondisi sewa' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Type'),
                value: _selectedType,
                items: typeList
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedType = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih type' : null,
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Periode Laptop'),
                value: _selectedPeriode,
                items: periodeList
                    .map((periode) => DropdownMenuItem(
                          value: periode,
                          child: Text(periode),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPeriode = value;
                  });
                },
                validator: (value) =>
                    value == null ? 'Pilih periode laptop' : null,
              ),
              TextFormField(
                controller: _spesifikasiController,
                decoration: const InputDecoration(
                  labelText: 'Spesifikasi',
                  hintText:
                      'e.g. Thinkpad L13 | Intel Core i5-10210U | 8GB RAM | 256GB SSD | Windows 10 Pro',
                ),
              ),
              TextFormField(
                controller: _serialNumberController,
                decoration: const InputDecoration(labelText: 'Serial Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Serial Number tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _namaKomputerController,
                decoration: const InputDecoration(labelText: 'Nama Komputer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama Komputer tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noBastController,
                decoration: const InputDecoration(labelText: 'No BAST'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No BAST tidak boleh kosong';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _noHbbController,
                decoration: const InputDecoration(labelText: 'No HBB'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'No HBB tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Penyedia'),
                value: _selectedPenyedia,
                items: penyediaList
                    .map((penyedia) => DropdownMenuItem(
                          value: penyedia,
                          child: Text(penyedia),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedPenyedia = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih penyedia' : null,
              ),
              TextFormField(
                controller: _keteranganController,
                decoration: const InputDecoration(labelText: 'Keterangan'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Keterangan tidak boleh kosong';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(labelText: 'Tahun'),
                value: _selectedTahun,
                items: tahunList
                    .map((tahun) => DropdownMenuItem(
                          value: tahun,
                          child: Text(tahun),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedTahun = value;
                  });
                },
                validator: (value) => value == null ? 'Pilih tahun' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    saveData();
                  }
                },
                child: const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
