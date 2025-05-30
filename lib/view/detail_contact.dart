import 'package:aplikasi_kontak/view/contact.dart';
import 'package:aplikasi_kontak/view/edit_akun.dart';
import 'package:aplikasi_kontak/view/edit_contact.dart';
import 'package:aplikasi_kontak/view/login.dart';
import 'package:aplikasi_kontak/view/new_contact.dart'; // Pastikan file ini ada
import 'package:flutter/material.dart';

class DetailContact extends StatefulWidget {
  const DetailContact({super.key});

  @override
  State<DetailContact> createState() => _DetailContactState();
}

class _DetailContactState extends State<DetailContact> {
  int _selectedIndex = 0;

  void _onNavTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const NewContact()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => Contact(),
        ), // Ganti 'yasir' dengan username yang sesuai
      );
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
                      "U", // Atau bisa dikosongkan ''
                      style: const TextStyle(
                        fontSize: 40,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "", // Tidak ada username
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
                  MaterialPageRoute(
                    builder: (_) => Contact(),
                  ), // Ganti 'yasir' dengan username yang sesuai
                );
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
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Container(
            width: 400,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: IconButton(
                    icon: Icon(Icons.arrow_back, color: Colors.blue),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const Contact()),
                      );
                    },
                  ),
                ),
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue.shade100,
                  child: Icon(Icons.person, size: 48, color: Colors.blue),
                ),
                const SizedBox(height: 16),
                Text(
                  "Nama Kontak",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Company Name",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                  ),
                ),
                const Divider(height: 32, thickness: 1),
                ListTile(
                  leading: Icon(Icons.phone, color: Colors.blue),
                  title: Text(
                    "08123456789",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Phone"),
                ),
                ListTile(
                  leading: Icon(Icons.email, color: Colors.blue),
                  title: Text(
                    "email@email.com",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("Email"),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Aksi edit atau kembali
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const EditContact()),
                      );
                    },
                    icon: Icon(Icons.edit, color: Colors.white),
                    label: Text(
                      "Edit Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    onPressed: () {
                      // Aksi hapus contact
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Hapus Kontak'),
                          content: Text(
                              'Apakah Anda yakin ingin menghapus kontak ini?'),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () {
                                // Proses hapus kontak di sini
                                Navigator.pop(context); // Tutup dialog
                                Navigator.pop(
                                    context); // Kembali ke halaman sebelumnya
                                // Atau bisa pushReplacement ke Contact()
                              },
                              child: Text('Hapus',
                                  style: TextStyle(color: Colors.red)),
                            ),
                          ],
                        ),
                      );
                    },
                    icon: Icon(Icons.delete, color: Colors.white),
                    label: Text(
                      "Hapus Contact",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
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
