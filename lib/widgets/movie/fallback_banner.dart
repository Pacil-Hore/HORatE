import 'package:flutter/material.dart';

class MovieFallbackBanner extends StatelessWidget {
  const MovieFallbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: const Icon(Icons.movie, size: 100, color: Colors.grey),
    );
  }
}
