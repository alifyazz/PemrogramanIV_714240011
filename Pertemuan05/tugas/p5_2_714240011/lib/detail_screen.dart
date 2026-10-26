import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String nama;
  final String npm;

  const DetailScreen({
    super.key,
    required this.nama,
    required this.npm,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> activityImages = [
      'assets/images/seaworld.jpeg',
      'assets/images/syana.jpeg',
      'assets/images/postud kelas.jpeg',
      'assets/images/postud syana.jpeg',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Profil',
          style: TextStyle(
            fontFamily: 'PlayfairDisplay',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 145, 95, 125 ),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nama,
              style: const TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 74, 48, 65),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'NPM: $npm',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Color.fromARGB(255, 73, 72, 72),
              ),
            ),
            const SizedBox(height: 28),

            const Text(
              'Tentang Saya & Hobi',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Saya adalah mahasiswa D4 Teknik Informatika yang memiliki ketertarikan besar di bidang UI/UX Design. Di luar kegiatan akademik, saya aktif bergabung dalam UKM Dance di kampus. Di waktu luang, saya suka mendengarkan musik, bermain game, serta membuat berbagai kerajinan tangan.',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14, 
                height: 1.6,
              ),
              textAlign: TextAlign.justify,
            ),
            const SizedBox(height: 24),

            const Text(
              'Gallery Aktivitas',
              style: TextStyle(
                fontFamily: 'PlayfairDisplay',
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 160,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: activityImages.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                      child: Image.asset(
                        activityImages[index],
                        width: 220,
                        height: 160,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 32),

            Center(
              child: OutlinedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                ),
                child: const Text(
                  'Kembali',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}