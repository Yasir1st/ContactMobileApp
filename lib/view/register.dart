import 'package:aplikasi_kontak/view/login.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasi_kontak/api/api_constants.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _username;
  String? _password;
  bool viewPass = true;

  void showHide() {
    setState(() {
      viewPass = !viewPass;
    });
  }

  void check() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      register();
    }
  }

  Future<void> register() async {
    final response = await http.post(
      Uri.parse(ApiConstants.register),
      body: {
        'name': _name ?? '',
        'username': _username ?? '',
        'password': _password ?? '',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int flag = data['flag'];
      String pesan = data['message'];
      if (flag == 1) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Registrasi berhasil, silakan login.")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Login()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(pesan)),
          );
        }
      }
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('Register failed. Status code: ${response.statusCode}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 100),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Logo dan Judul
              Container(
                margin: const EdgeInsets.only(bottom: 32),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: Colors.blue.shade100,
                      child: const Icon(
                        Icons.contacts,
                        size: 35,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "MyContact",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue[800],
                          ),
                        ),
                        Text(
                          "Save Your Contact Properly",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _name = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan nama' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
                onSaved: (value) => _username = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan username' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: viewPass,
                onSaved: (value) => _password = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Masukkan password' : null,
              ),
              const SizedBox(height: 15),
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
                  onPressed: check,
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Login()),
                      );
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
