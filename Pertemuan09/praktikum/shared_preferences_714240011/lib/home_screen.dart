import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_screen.dart';

class MyHome extends StatefulWidget {
  const MyHome({super.key});

  @override
  State<MyHome> createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  // G.1 Buat variabel
  late SharedPreferences logindata;
  String username = ""; // Jawaban Challenge: Inisialisasi awal agar tidak null

  @override
  void initState() {
    super.initState();
    initial();
  }

  // G.2 Buat method initial()
  void initial() async {
    logindata = await SharedPreferences.getInstance();
    setState(() {
      username = logindata.getString('username') ?? "";
    });
  }

 @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center( // Tambahkan widget Center ini
        child: Padding(
          padding: const EdgeInsets.only(top: 16), // Beri jarak sedikit dari atas
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start, // Ini memastikan tetap di atas
            children: [
              const Text('Welcome to Home'),
              const SizedBox(height: 20),
              Text(username),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // G.4 Tambah method setBool() dan remove()
                  logindata.setBool('login', true);
                  logindata.remove('username');

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                  );
                },
                child: const Text('Logout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}