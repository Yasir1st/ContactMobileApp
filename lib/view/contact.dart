import 'package:aplikasi_kontak/view/detail_contact.dart';
import 'package:aplikasi_kontak/view/edit_akun.dart';
import 'package:aplikasi_kontak/view/login.dart';
import 'package:aplikasi_kontak/view/new_contact.dart'; // Pastikan file ini ada
import 'package:flutter/material.dart';

class Contact extends StatefulWidget {
  final String? username; // nama orang login
  const Contact({super.key, this.username});

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  // Contoh data kontak
  List<Map<String, String>> contacts = [
    {"name": "Ari Wibowo", "phone": "08123456789"},
    {"name": "Budi Santoso", "phone": "08234567890"},
    {"name": "Citra Dewi", "phone": "08345678901"},
    {"name": "Dewi Lestari", "phone": "08456789012"},
    {"name": "Eko Prasetyo", "phone": "08567890123"},
  ];

  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const NewContact()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                      (widget.username != null && widget.username!.isNotEmpty)
                          ? widget.username![0].toUpperCase()
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
                    widget.username ?? '',
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
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // tutup drawer
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_add),
              title: const Text('Add New Contact'),
              onTap: () {
                Navigator.pop(context); // tutup drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const NewContact()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.edit),
              title: const Text('Edit Akun'),
              onTap: () {
                // Navigasi ke halaman Edit Akun
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
                // Aksi hapus akun, misal tampilkan konfirmasi
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
                          // Proses hapus akun di sini
                          Navigator.pop(context); // Tutup dialog
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
        backgroundColor: Colors.blue, // warna biru appbar
        iconTheme: const IconThemeData(
          color: Colors.white, // Ubah warna icon drawer (menu) jadi putih
        ),
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
                    color: Colors.white, // teks putih
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
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          itemCount: contacts.length,
          separatorBuilder: (context, index) =>
              const Divider(indent: 70, endIndent: 20),
          itemBuilder: (context, index) {
            final contact = contacts[index];
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue.shade100,
                child: Text(
                  contact['name']![0],
                  style: TextStyle(
                    color: Colors.blue[900],
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                contact['name']!,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(contact['phone']!),
              onTap: () {
                // Aksi ketika kontak diklik
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DetailContact()),
                );
              },
            );
          },
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
