import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';

class GitHubUpdateService {
  final String owner;
  final String repo;

  GitHubUpdateService({required this.owner, required this.repo});

  Future<void> checkForUpdates(BuildContext context) async {
    try {
      final latestRelease = await _getLatestRelease();
      if (latestRelease == null) return;

      final latestVersion = latestRelease['tag_name']?.toString().replaceAll(
        'v',
        '',
      );
      if (latestVersion == null) return;

      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final latestSemVer = Version.parse(latestVersion);
      final currentSemVer = Version.parse(currentVersion);

      if (latestSemVer > currentSemVer) {
        if (context.mounted) {
          _showUpdateDialog(context, latestVersion, latestRelease['html_url']);
        }
      }
    } catch (e) {
      debugPrint('Error checking for updates: $e');
    }
  }

  Future<Map<String, dynamic>?> _getLatestRelease() async {
    final url = Uri.parse(
      'https://api.github.com/repos/$owner/$repo/releases/latest',
    );
    debugPrint('URL: ${url}');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      debugPrint('Failed to load latest release: ${response.statusCode}');
      return null;
    }
  }

  void _showUpdateDialog(BuildContext context, String version, String url) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Available'),
          content: Text(
            'A new version ($version) is available. Would you like to update?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Later'),
            ),
            ElevatedButton(
              onPressed: () async {
                final uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }
}
