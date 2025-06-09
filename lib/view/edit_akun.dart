import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:aplikasi_kontak/api/api_constants.dart';

class EditAkun extends StatefulWidget {
  final int? userId;
  const EditAkun({super.key, this.userId});

  @override
  State<EditAkun> createState() => _EditAkunState();
}

class _EditAkunState extends State<EditAkun> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  String _password = '';
  String _confirmPassword = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    if (widget.userId != null) {
      fetchUserData(widget.userId!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> fetchUserData(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.user}?id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['data'];
      setState(() {
        _usernameController.text = user['username'] ?? '';
        _nameController.text = user['name'] ?? '';
      });
    }
  }

  Future<void> updateUser() async {
    final url = Uri.parse('${ApiConstants.updateUser}?id=${widget.userId}');
    final body = {
      'username': _usernameController.text,
      'password': _password,
      'confirm_password': _confirmPassword,
      'name': _nameController.text,
    };
    final response = await http.put(url, body: body);
    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['message'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['error'] ?? 'Gagal update akun')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Edit Akun',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 32),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const SizedBox(height: 24),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nama',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan nama' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) => _password = value,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan password' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
                onChanged: (value) => _confirmPassword = value,
                validator: (value) => value == null || value.isEmpty
                    ? 'Konfirmasi password'
                    : (value != _password ? 'Password tidak sama' : null),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      _formKey.currentState?.save();
                      updateUser();
                    }
                  },
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
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
