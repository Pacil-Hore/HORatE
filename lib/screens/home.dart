import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:horate/models/genre.dart';
import 'package:horate/models/media.dart';
import 'package:horate/widgets/media_card.dart';
import 'package:horate/widgets/app_drawer.dart';
import 'package:horate/screens/movie_detail.dart';
import 'package:horate/screens/tv_detail.dart';

enum MediaType { movie, tv }

class HomeFlexiblePage extends StatefulWidget {
  final MediaType mode;
  const HomeFlexiblePage({Key? key, required this.mode}) : super(key: key);

  @override
  State<HomeFlexiblePage> createState() => _HomeFlexiblePageState();
}

class _HomeFlexiblePageState extends State<HomeFlexiblePage> {
  final String tmdbBearerToken = dotenv.env['TMDB_BEARER_TOKEN'] ?? '';

  final TextEditingController _searchController = TextEditingController();

  List<TmdbMediaItem> items = <TmdbMediaItem>[];
  bool isLoading = false;
  String? errorMessage;

  int currentPage = 1;
  int totalPages = 1;

  List<Genre> genres = <Genre>[];
  int? selectedGenreId;

  Map<String, String> get _headers => {
    'Authorization': 'Bearer $tmdbBearerToken',
    'Content-Type': 'application/json',
  };

  String get _modeKey => widget.mode == MediaType.movie ? 'movie' : 'tv';

  String get _title => widget.mode == MediaType.movie ? 'HORatE Movies' : 'HORatE TV';

  // URL fleksibel
  String get discoverUrl => 'https://api.themoviedb.org/3/discover/$_modeKey';
  String get searchUrl => 'https://api.themoviedb.org/3/search/$_modeKey';
  String get genreUrl => 'https://api.themoviedb.org/3/genre/$_modeKey/list';

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  Future<void> _initLoad() async {
    await fetchGenres();
    await fetchItems(reset: true);
  }

  Future<void> fetchGenres() async {
    try {
      final uri = Uri.parse('$genreUrl?language=en-US');
      final res = await http.get(uri, headers: _headers);

      if (res.statusCode == 200) {
        final parsed = tmdbGenreResponseFromJson(res.body);
        setState(() => genres = parsed.genres);
      } else {
        setState(() {
          genres = <Genre>[];
          errorMessage = 'Failed to fetch genre (${res.statusCode})';
        });
      }
    } catch (e) {
      setState(() {
        genres = <Genre>[];
        errorMessage = 'Failed to fetch genre: $e';
      });
    }
  }

  Future<void> fetchItems({bool reset = false}) async {
    if (isLoading) return;

    if (reset) {
      setState(() {
        items = <TmdbMediaItem>[];
        currentPage = 1;
        totalPages = 1;
        errorMessage = null;
      });
    }

    if (currentPage > totalPages) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final q = _searchController.text.trim();
      Uri uri;

      if (q.isNotEmpty) {
        uri = Uri.parse(
          '$searchUrl'
              '?query=${Uri.encodeQueryComponent(q)}'
              '&include_adult=false'
              '&language=en-US'
              '&page=$currentPage',
        );
      } else {
        final genreParam = selectedGenreId == null ? '' : '&with_genres=$selectedGenreId';

        uri = Uri.parse(
          '$discoverUrl'
              '?sort_by=popularity.desc'
              '&include_adult=false'
              '&language=en-US'
              '&page=$currentPage'
              '$genreParam',
        );
      }

      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final parsed = tmdbDiscoverResponseFromJson(response.body);
        var incoming = parsed.results;

        // search + genre -> filter lokal
        if (q.isNotEmpty && selectedGenreId != null) {
          incoming = incoming.where((m) => m.genreIds.contains(selectedGenreId)).toList();
        }

        setState(() {
          items.addAll(incoming);
          totalPages = parsed.totalPages;
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to fetch (${response.statusCode})';
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

  void loadMore() {
    if (!isLoading && currentPage < totalPages) {
      setState(() => currentPage++);
      fetchItems();
    }
  }

  void onSearch() => fetchItems(reset: true);

  void onGenreChanged(int? newGenreId) {
    setState(() => selectedGenreId = newGenreId);
    fetchItems(reset: true);
  }

  @override
  Widget build(BuildContext context) {
    final genreItems = <DropdownMenuItem<int?>>[
      const DropdownMenuItem<int?>(
        value: null,
        child: Row(
          children: [
            Icon(Icons.movie_filter, size: 20, color: Colors.deepPurple),
            SizedBox(width: 8),
            Text('All'),
          ],
        ),
      ),
      ...genres.map((g) {
        return DropdownMenuItem<int?>(
          value: g.id,
          child: Row(
            children: [
              const Icon(Icons.movie_filter, size: 20, color: Colors.deepPurple),
              const SizedBox(width: 8),
              Text(g.name),
            ],
          ),
        );
      }).toList(),
    ];

    return Scaffold(
      drawer: AppDrawer(current: _modeKey), // 'movie' atau 'tv'
      appBar: AppBar(
        title: Text(_title),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Search
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: widget.mode == MediaType.movie ? 'Search movies...' : 'Search TV...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    onSubmitted: (_) => onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onSearch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Icon(Icons.search),
                ),
              ],
            ),
          ),

          // Genre dropdown
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int?>(
                  value: selectedGenreId,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: genreItems,
                  onChanged: onGenreChanged,
                ),
              ),
            ),
          ),

          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                errorMessage!,
                style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w500),
              ),
            ),

          Expanded(
            child: items.isEmpty && isLoading
                ? const Center(child: CircularProgressIndicator())
                : items.isEmpty
                ? const Center(child: Text('No results'))
                : NotificationListener<ScrollNotification>(
              onNotification: (scrollInfo) {
                if (!isLoading &&
                    scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
                  loadMore();
                }
                return false;
              },
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.6,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: items.length + (isLoading ? 2 : 0),
                itemBuilder: (context, index) {
                  if (index >= items.length) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final item = items[index];

                  return GestureDetector(
                    onTap: () {
                      if (widget.mode == MediaType.movie) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MovieDetailPage(
                              tmdbMovieId: item.id,
                              movieTitle: item.title,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => TvDetailPage(tmdbTvId: item.id),
                          ),
                        );
                      }
                    },
                    child: TmdbMediaCard(item: item),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}