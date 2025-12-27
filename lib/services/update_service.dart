import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pub_semver/pub_semver.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'package:ota_update/ota_update.dart';

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
          _showUpdateDialog(context, latestVersion, latestRelease);
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
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      debugPrint('Failed to load latest release: ${response.statusCode}');
      return null;
    }
  }

  void _showUpdateDialog(
    BuildContext context,
    String version,
    Map<String, dynamic> release,
  ) {
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
                Navigator.pop(context);
                await _handleUpdate(context, release);
              },
              child: const Text('Update Now'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _handleUpdate(
    BuildContext context,
    Map<String, dynamic> release,
  ) async {
    final htmlUrl = release['html_url'] as String;
    final assets = release['assets'] as List<dynamic>?;

    String? apkUrl;
    if (assets != null) {
      for (var asset in assets) {
        final name = asset['name'] as String;
        if (name.endsWith('.apk')) {
          apkUrl = asset['browser_download_url'] as String;
          break;
        }
      }
    }

    if (Platform.isAndroid && apkUrl != null) {
      try {
        _showDownloadProgress(context, apkUrl);
      } catch (e) {
        debugPrint('Error starting OTA update: $e');
        _launchUrl(htmlUrl);
      }
    } else {
      _launchUrl(htmlUrl);
    }
  }

  void _showDownloadProgress(BuildContext context, String apkUrl) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StreamBuilder<OtaEvent>(
          stream: OtaUpdate().execute(
            apkUrl,
            destinationFilename: 'mentalpulse_update.apk',
          ),
          builder: (context, snapshot) {
            String status = 'Initializing...';
            double? progress;

            if (snapshot.hasData) {
              switch (snapshot.data!.status) {
                case OtaStatus.DOWNLOADING:
                  status = 'Downloading update...';
                  progress = double.tryParse(snapshot.data!.value!)! / 100;
                  break;
                case OtaStatus.INSTALLING:
                  status = 'Installing...';
                  // Close dialog safely after build
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true).pop();
                    }
                  });
                  break;
                case OtaStatus.INSTALLATION_DONE:
                  status = 'Installation complete';
                  break;
                case OtaStatus.ALREADY_RUNNING_ERROR:
                  status = 'Update already running';
                  break;
                case OtaStatus.PERMISSION_NOT_GRANTED_ERROR:
                  status = 'Permission not granted';
                  break;
                case OtaStatus.INTERNAL_ERROR:
                  status = 'Internal error occurred';
                  break;
                case OtaStatus.DOWNLOAD_ERROR:
                  status = 'Download failed';
                  break;
                case OtaStatus.CHECKSUM_ERROR:
                  status = 'Checksum error';
                  break;
                default:
                  status = 'Unknown status';
                  break;
              }
            } else if (snapshot.hasError) {
              status = 'Error: ${snapshot.error}';
            }

            return AlertDialog(
              title: const Text('Updating'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(status),
                  const SizedBox(height: 16),
                  LinearProgressIndicator(value: progress),
                  if (snapshot.hasError ||
                      (snapshot.hasData &&
                          (snapshot.data!.status == OtaStatus.DOWNLOAD_ERROR ||
                              snapshot.data!.status ==
                                  OtaStatus.INTERNAL_ERROR)))
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
