import 'package:url_launcher/url_launcher.dart';

bool looksLikeUrl(String? url) {
  if (url == null) return false;
  final u = url.trim();
  if (u.isEmpty) return false;
  final uri = Uri.tryParse(u);
  return uri != null && (uri.isScheme('http') || uri.isScheme('https'));
}

Future<bool> openExternalUrl(String url) async {
  final uri = Uri.tryParse(url);
  if (uri == null) return false;
  return launchUrl(uri, mode: LaunchMode.externalApplication);
}
