import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'contact.dart';
import 'edit_akun.dart';
import 'login.dart';
import 'package:aplikasi_kontak/api/api_constants.dart';

class NewContact extends StatefulWidget {
  const NewContact({super.key});

  @override
  State<NewContact> createState() => _NewContactState();
}

class _NewContactState extends State<NewContact> {
  final _formKey = GlobalKey<FormState>();
  String _phone = '';
  String _email = '';
  String _company = '';
  String _firstName = '';
  String _lastName = '';
  String? name;
  int? userId;
  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getUserIdAndFetchName();
  }

  void getUserIdAndFetchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getInt('user_id');
    if (userId != null) {
      fetchUserData(userId!);
    }
  }

  Future<void> fetchUserData(int userId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.user}?id=$userId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final user = data['data'];
      setState(() {
        name = user['name'] ?? '';
      });
    }
  }

  Future<void> addContact() async {
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User ID tidak ditemukan')),
      );
      return;
    }

    final fullName = '$_firstName $_lastName'.trim();

    final url = Uri.parse(ApiConstants.createContact);
    final response = await http.post(
      url,
      body: {
        'user_id': userId.toString(),
        'name': fullName,
        'phone': _phone,
        'email': _email,
        'company': _company,
      },
    );
    final data = jsonDecode(response.body);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data['message'] ?? 'Gagal menambah kontak')),
    );

    if (response.statusCode == 200 &&
        data['message'] != null &&
        data['message'].toString().contains('success')) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Contact()),
      );
    }
  }

  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NewContact()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => Contact()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundColor: Colors.white,
                    child: Text(
                      (name != null && name!.isNotEmpty)
                          ? name![0].toUpperCase()
                          : '',
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    name ?? '',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.contacts),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Contact()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add New Contact'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const NewContact()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Akun'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditAkun()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Hapus Akun'),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Hapus Akun'),
                    content: const Text(
                        'Apakah Anda yakin ingin menghapus akun ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          );
                        },
                        child: const Text('Hapus',
                            style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.shade100,
              child: const Icon(Icons.contacts, color: Colors.blue),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "MyContact",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  "Save Your Contact Properly",
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
            const Spacer(),
            IconButton(
              icon: const Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const Login()),
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 30, right: 30, top: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add New Contact",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.blue[900],
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _firstName = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Masukkan first name'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _lastName = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(),
                    ),
                    onSaved: (value) => _company = value ?? '',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    onSaved: (value) => _phone = value ?? '',
                    validator: (value) => value == null || value.isEmpty
                        ? 'Masukkan nomor telepon'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onSaved: (value) => _email = value ?? '',
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
                          addContact();
                        }
                      },
                      child: const Text(
                        'Save Contact',
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
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onNavTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.contacts),
            label: 'Contact',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_add),
            label: 'Add New Contact',
          ),
        ],
      ),
    );
  }
}
