import 'package:aplikasi_kontak/view/contact.dart';
import 'package:aplikasi_kontak/view/register.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasi_kontak/api/api_constants.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? _username;
  String? _password;
  final _formKey = GlobalKey<FormState>();
  bool viewPass = true;
  int? flag;

  @override
  void initState() {
    super.initState();
    getPref();
  }

  void check() {
    final form = _formKey.currentState;
    if (form != null && form.validate()) {
      form.save();
      login();
    }
  }

  Future<void> login() async {
    final response = await http.post(
      Uri.parse(ApiConstants.login),
      body: {
        'username': _username ?? '',
        'password': _password ?? '',
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      int flag = data['flag'];
      String pesan = data['message'];
      if (flag == 1) {
        setState(() {
          savePref(flag);
        });

        // Simpan user_id ke SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (data['id'] != null) {
          prefs.setInt('user_id', int.parse(data['id'].toString()));
        }

        // Navigasi ke Contact hanya jika login berhasil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Contact()),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login sebagai $_username')),
        );
      } else {
        // Tampilkan pesan error jika login gagal
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(pesan)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Login failed. Status code: ${response.statusCode}')),
      );
    }
  }

  void showHide() {
    setState(() {
      viewPass = !viewPass;
    });
  }

  Future<void> savePref(int flag) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt("flag", flag);
  }

  Future<void> getPref() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      flag = preferences.getInt("flag");
    });
  }

  Future<void> logOut() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove("flag");
    setState(() {});
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
        padding: const EdgeInsets.only(left: 30, right: 30, top: 120),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Logo Kontak sebelum TextFormField
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
                    'Login',
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
                  const Text("I don't have account ? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Register()),
                      );
                    },
                    child: const Text(
                      "Register",
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
