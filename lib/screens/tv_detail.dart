import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:horate/models/tv.dart';
import 'package:horate/helpers/url_helper.dart';

import 'package:horate/widgets/common/trailer_card.dart';
import 'package:horate/widgets/common/link_card.dart';
import 'package:horate/widgets/tv/episode_card.dart';
import 'package:horate/widgets/common/section_card.dart';
import 'package:horate/widgets/common/info_row.dart';
import 'package:horate/widgets/common/chips.dart';
import 'package:horate/widgets/tv/fallback_banner.dart';

class TvDetailPage extends StatefulWidget {
  final int tmdbTvId;
  final String? tvTitle;

  const TvDetailPage({
    Key? key,
    required this.tmdbTvId,
    this.tvTitle,
  }) : super(key: key);

  @override
  State<TvDetailPage> createState() => _TvDetailPageState();
}

class _TvDetailPageState extends State<TvDetailPage> {
  final String tmdbBearerToken = dotenv.env['TMDB_BEARER_TOKEN'] ?? '';

  TmdbTvDetail? tv;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchTvDetail();
  }

  Future<void> fetchTvDetail() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final url = Uri.parse(
        'https://api.themoviedb.org/3/tv/${widget.tmdbTvId}'
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
        final data = tmdbTvDetailFromJson(response.body);
        setState(() {
          tv = data;
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
            if (widget.tvTitle != null) ...[
              const SizedBox(height: 16),
              Text(
                'Loading ${widget.tvTitle}...',
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
    final t = tv!;
    final trailer = t.videos?.firstTrailer;

    final String? homepageUrl = (t as dynamic).homepage?.toString();
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
                if (t.backdropUrl() != null)
                  Image.network(
                    t.backdropUrl()!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const TvFallbackBanner(),
                  )
                else if (t.posterUrl(size: 'w780') != null)
                  Image.network(
                    t.posterUrl(size: 'w780')!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => const TvFallbackBanner(),
                  )
                else
                  const TvFallbackBanner(),
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
                  t.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (t.tagline.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    t.tagline,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
                const SizedBox(height: 10),

                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    CommonChip(t.year),
                    CommonChip(t.runtimeText),
                    if (t.status.isNotEmpty) CommonChip(t.status),
                    if (t.numberOfSeasons > 0)
                      CommonChip('${t.numberOfSeasons} seasons'),
                    if (t.numberOfEpisodes > 0)
                      CommonChip('${t.numberOfEpisodes} eps'),
                  ],
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      '${t.voteAverage.toStringAsFixed(1)}/10',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '(${t.voteCount} votes)',
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
                  const SizedBox(height: 16),
                  CommonLinkCard(
                    label: 'Open Homepage',
                    title: homepageUrl!.trim(),
                    hint: 'Tap to open website',
                    icon: Icons.public,
                    iconColor: Colors.lightBlueAccent,
                    borderColor: Colors.lightBlueAccent.withOpacity(0.35),
                    onTap: () => _openUrl(homepageUrl.trim()),
                  ),
                ],

                const SizedBox(height: 24),

                if (t.genres.isNotEmpty) ...[
                  const CommonSectionTitle('Genre'),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: t.genres.map((g) => TvGenreChip(g.name)).toList(),
                  ),
                  const SizedBox(height: 24),
                ],

                if (t.overview.isNotEmpty) ...[
                  const CommonSectionTitle('Overview'),
                  Text(
                    t.overview,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                ],

                if (t.createdBy.isNotEmpty)
                  CommonInfoRow(
                    label: 'Created by',
                    value: t.createdBy.map((c) => c.name).take(4).join(', '),
                  ),

                if (t.networks.isNotEmpty)
                  CommonInfoRow(
                    label: 'Network',
                    value: t.networks.map((n) => n.name).take(3).join(', '),
                  ),

                if (t.firstAirDate.isNotEmpty)
                  CommonInfoRow(label: 'First air date', value: t.firstAirDate),

                if (t.lastAirDate.isNotEmpty)
                  CommonInfoRow(label: 'Last air date', value: t.lastAirDate),

                if (t.lastEpisodeToAir != null) ...[
                  const SizedBox(height: 10),
                  TvEpisodeCard(
                    label: 'Last episode',
                    epName: t.lastEpisodeToAir!.name,
                    airDate: t.lastEpisodeToAir!.airDate,
                    meta:
                    'S${t.lastEpisodeToAir!.seasonNumber} • E${t.lastEpisodeToAir!.episodeNumber}',
                  ),
                ],
                if (t.nextEpisodeToAir != null) ...[
                  const SizedBox(height: 10),
                  TvEpisodeCard(
                    label: 'Next episode',
                    epName: t.nextEpisodeToAir!.name,
                    airDate: t.nextEpisodeToAir!.airDate,
                    meta:
                    'S${t.nextEpisodeToAir!.seasonNumber} • E${t.nextEpisodeToAir!.episodeNumber}',
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }

  _TrailerInfo? _firstYoutubeTrailer(TmdbTvDetail t) {
    try {
      final dyn = t as dynamic;
      final videos = dyn.videos;
      final results = videos?.results as List<dynamic>?;
      if (results == null || results.isEmpty) return null;

      Map<String, dynamic>? pick;

      for (final r in results) {
        final m = (r as Map).cast<String, dynamic>();
        final site = (m['site'] ?? '').toString().toLowerCase();
        final type = (m['type'] ?? '').toString().toLowerCase();
        if (site == 'youtube' && type == 'trailer') {
          pick = m;
          break;
        }
      }

      pick ??= results
          .map((e) => (e as Map).cast<String, dynamic>())
          .firstWhere(
            (m) =>
        (m['site'] ?? '').toString().toLowerCase() == 'youtube' &&
            (m['type'] ?? '').toString().toLowerCase() == 'teaser',
        orElse: () => <String, dynamic>{},
      );

      if (pick == null || pick.isEmpty) return null;

      final key = (pick['key'] ?? '').toString();
      if (key.isEmpty) return null;

      final name = (pick['name'] ?? 'Trailer').toString();
      return _TrailerInfo(
        title: name,
        youtubeUrl: 'https://www.youtube.com/watch?v=$key',
      );
    } catch (_) {
      return null;
    }
  }
}

class _TrailerInfo {
  final String title;
  final String youtubeUrl;

  _TrailerInfo({required this.title, required this.youtubeUrl});
}
