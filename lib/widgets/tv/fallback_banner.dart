import 'package:flutter/material.dart';

class TvFallbackBanner extends StatelessWidget {
  const TvFallbackBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey[900],
      child: const Icon(Icons.tv, size: 100, color: Colors.grey),
    );
  }
}
