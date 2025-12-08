import "package:flutter/material.dart";
import "package:sport_zone/screens/admin.dart";

class Profile extends StatelessWidget {
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    // Anggap ini didapat dari API saat login
    bool isAdmin = true;

    return Scaffold(
      appBar: AppBar(title: const Text('PROFIL SAYA')),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ... (Bagian Foto Profil User seperti desain sebelumnya) ...
            const SizedBox(height: 20),

            // === MENU KHUSUS ADMIN ===
            if (isAdmin)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.black, // Background hitam agar menonjol
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Admin Area', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Text('Kelola user, produk & log', style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () {
                        // Navigasi ke Halaman Admin (Kode admin_main.dart sebelumnya)
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const AdminMainScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                      child: const Text('Buka Dashboard'),
                    )
                  ],
                ),
              ),

            // ... (Menu User Biasa: Edit Profile, Logout, dll) ...
          ],
        ),
      ),
    );
  }
}
