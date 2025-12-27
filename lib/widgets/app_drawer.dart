import 'package:flutter/material.dart';

import 'package:horate/screens/home.dart'; // MovieHomePage
import 'package:horate/screens/home.dart'; // TvHomePage (buat di step 2)

class AppDrawer extends StatelessWidget {
  final String current; // 'movies' | 'tv'

  const AppDrawer({Key? key, required this.current}) : super(key: key);

  void _go(BuildContext context, Widget page) {
    // Tutup drawer dulu
    Navigator.pop(context);

    // Ganti halaman (replace) biar ga numpuk stack
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMovies = current == 'movies';
    final isTv = current == 'tv';

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const ListTile(
              leading: Icon(Icons.local_movies),
              title: Text(
                'HORatE',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text('Browse Movies & TV'),
            ),
            const Divider(),

            ListTile(
              leading: Icon(isMovies ? Icons.movie : Icons.movie_outlined),
              title: const Text('Movies'),
              selected: isMovies,
              onTap: isMovies
                  ? () => Navigator.pop(context)
                  : () => _go(context, const HomeFlexiblePage(mode: MediaType.movie)),
            ),

            ListTile(
              leading: Icon(isTv ? Icons.tv : Icons.tv_outlined),
              title: const Text('TV Shows'),
              selected: isTv,
              onTap: isTv
                  ? () => Navigator.pop(context)
                  : () => _go(context, const HomeFlexiblePage(mode: MediaType.tv)),
            ),

            const Spacer(),
            const Divider(),
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text(
                'Tip: gunakan drawer untuk pindah kategori.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}