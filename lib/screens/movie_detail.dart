import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:horate/models/movie.dart';
import 'package:horate/helpers/url_helper.dart'; // pakai yg dari TV

import 'package:horate/widgets/common/trailer_card.dart';
import 'package:horate/widgets/common/link_card.dart';
import 'package:horate/widgets/common/section_card.dart';
import 'package:horate/widgets/common/info_row.dart';
import 'package:horate/widgets/common/chips.dart';
import 'package:horate/widgets/movie/fallback_banner.dart';

class MovieDetailPage extends StatefulWidget {
  final int tmdbMovieId;
  final String? movieTitle;

  const MovieDetailPage({
    Key? key,
    required this.tmdbMovieId,
    this.movieTitle,
  }) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final String tmdbBearerToken = dotenv.env['TMDB_BEARER_TOKEN'] ?? '';

  MovieDetail? movie;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchMovieDetail();
  }

  Future<void> fetchMovieDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse(
        'https://api.themoviedb.org/3/movie/${widget.tmdbMovieId}'
            '?append_to_response=videos,images,credits'
            '&language=en-US',
      );

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $tmdbBearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = tmdbMovieDetailFromJson(response.body);
        setState(() {
          movie = data;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch data (${response.statusCode})';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        isLoading = false;
      });
    }
  }

  Future<void> _openUrl(String url) async {
    final ok = await openExternalUrl(url);
    if (!ok && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Tidak bisa membuka link')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: isLoading
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(color: Colors.white),
            if (widget.movieTitle != null) ...[
              const SizedBox(height: 16),
              Text(
                'Loading ${widget.movieTitle}...',
                style: const TextStyle(color: Colors.white70),
              ),
            ],
          ],
        ),
      )
          : errorMessage != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline,
                size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text(errorMessage!,
                style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Kembali'),
            ),
          ],
        ),
      )
          : _buildContent(context),
    );
  }

  Widget _buildContent(BuildContext context) {
    final m = movie!;
    final trailer = m.videos?.firstTrailer;

    final String? homepageUrl = m.homepage;
    final bool hasHomepage = looksLikeUrl(homepageUrl);

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          expandedHeight: 400,
          pinned: true,
          backgroundColor: Colors.black,
          flexibleSpace: FlexibleSpaceBar(
            background: Stack(
              fit: StackFit.expand,
              children: [
                if (m.backdropUrl() != null)
                  Image.network(
                    m.backdropUrl()!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const MovieFallbackBanner(),
                  )
                else if (m.posterUrl(size: 'w780') != null)
                  Image.network(
                    m.posterUrl(size: 'w780')!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const MovieFallbackBanner(),
                  )
                else
                  const MovieFallbackBanner(),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.7),
                        Colors.black,
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  m.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    CommonChip(m.year),
                    const SizedBox(width: 8),
                    CommonChip(m.runtimeText),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${m.voteAverage.toStringAsFixed(1)}/10',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${m.voteCount} votes)',
                      style: const TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),

                if (trailer?.youtubeUrl != null) ...[
                  const SizedBox(height: 16),
                  CommonTrailerCard(
                    title: trailer!.name,
                    onTap: () => _openUrl(trailer.youtubeUrl!),
                  ),
                ],

                if (hasHomepage) ...[
                  const SizedBox(height: 12),
                  CommonLinkCard(
                    label: 'Open Homepage',
                    title: homepageUrl!.trim(),
                    hint: 'Tap to open official website',
                    icon: Icons.public,
                    iconColor: Colors.lightBlueAccent,
                    borderColor: Colors.lightBlueAccent.withOpacity(0.35),
                    onTap: () => _openUrl(homepageUrl.trim()),
                  ),
                ],

                const SizedBox(height: 24),

                if (m.genres.isNotEmpty) ...[
                  const CommonSectionTitle('Genre'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: m.genres.map((g) => CommonChip(g.name)).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                if (m.overview.isNotEmpty) ...[
                  const CommonSectionTitle('Plot'),
                  Text(
                    m.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                if (m.credits != null) ...[
                  CommonInfoRow(label: 'Director', value: m.credits!.director),
                  CommonInfoRow(label: 'Cast', value: m.credits!.topCast),
                ],

                if (m.releaseDate.isNotEmpty)
                  CommonInfoRow(label: 'Released', value: m.releaseDate),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}