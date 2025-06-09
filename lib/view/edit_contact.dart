import 'dart:convert';
import 'package:aplikasi_kontak/view/edit_akun.dart';
import 'package:aplikasi_kontak/view/login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'contact.dart';
import 'new_contact.dart';
import 'package:aplikasi_kontak/api/api_constants.dart';

class EditContact extends StatefulWidget {
  final int contactId;
  const EditContact({super.key, required this.contactId});

  @override
  State<EditContact> createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  String? name;
  final int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    getUserIdAndFetchName();
    fetchContactDetail(widget.contactId);
  }

  void getUserIdAndFetchName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('user_id');
    if (userId != null) {
      fetchUserData(userId);
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

  Future<void> fetchContactDetail(int contactId) async {
    final response = await http.get(
      Uri.parse('${ApiConstants.detailContact}?id=$contactId'),
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['error'] == null) {
        setState(() {
          final name = data['name'] ?? '';
          final nameParts = name.split(' ');
          _firstNameController.text = nameParts.isNotEmpty ? nameParts[0] : '';
          _lastNameController.text =
              nameParts.length > 1 ? nameParts.sublist(1).join(' ') : '';
          _companyController.text = data['company'] ?? '';
          _phoneController.text = data['phone'] ?? '';
          _emailController.text = data['email'] ?? '';
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['error'])),
        );
      }
    }
  }

  Future<void> updateContact() async {
    final fullName =
        '${_firstNameController.text} ${_lastNameController.text}'.trim();
    final url = Uri.parse(
      '${ApiConstants.updateContact}?id=${widget.contactId}',
    );

    final body = {
      'name': fullName,
      'phone': _phoneController.text,
      'email': _emailController.text,
      'company': _companyController.text,
      'message': '', // Jika tidak ada field message, bisa dikosongkan
    };

    final response = await http.put(
      url,
      headers: {'Content-Type': 'application/x-www-form-urlencoded'},
      body: body,
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['message'] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['message'])),
      );
      Navigator.pop(context, true); // Kirim true ke halaman sebelumnya
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(data['error'] ?? 'Gagal update kontak')),
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
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _companyController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
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
              decoration: BoxDecoration(color: Colors.blue),
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
                      style: TextStyle(
                        fontSize: 40,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    name ?? '',
                    style: TextStyle(
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
                  MaterialPageRoute(builder: (_) => Contact()),
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
                    title: Text('Hapus Akun'),
                    content:
                        Text('Apakah Anda yakin ingin menghapus akun ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const Login()),
                          );
                        },
                        child:
                            Text('Hapus', style: TextStyle(color: Colors.red)),
                      ),
                    ],
                  ),
                );
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blue.shade100,
              child: Icon(Icons.contacts, color: Colors.blue),
            ),
            SizedBox(width: 10),
            Column(
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
            Spacer(),
            IconButton(
              icon: Icon(Icons.logout, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => Login()),
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
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.blue),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                SizedBox(width: 4),
                Text(
                  "Edit Contact",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _firstNameController,
                    decoration: InputDecoration(
                      labelText: 'First Name',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Masukkan first name'
                        : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _lastNameController,
                    decoration: InputDecoration(
                      labelText: 'Last Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: 'Company',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.phone,
                    validator: (value) => value == null || value.isEmpty
                        ? 'Masukkan nomor telepon'
                        : null,
                  ),
                  SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                      onPressed: () {
                        if (_formKey.currentState?.validate() ?? false) {
                          updateContact();
                        }
                      },
                      child: Text(
                        'Save Changes',
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
