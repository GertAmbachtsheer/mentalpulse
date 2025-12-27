import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'services/location_service.dart';
import 'crisis_banner.dart';
import 'widgets/support_section.dart';
import 'widgets/keyboard_padding.dart';
import 'profile_page.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  User? _user;
  int? _selectedMoodIndex;
  bool _isLocationEnabled = false;
  final LocationService _locationService = LocationService();

  Future<void> _toggleLocation(bool value) async {
    debugPrint('LandingPage: Toggling location to $value');
    if (value) {
      final result = await _locationService.requestPermission();
      debugPrint('LandingPage: requestPermission result: $result');

      if (result == LocationResult.granted) {
        setState(() {
          _isLocationEnabled = true;
        });
        await _locationService.enableBackgroundMode(enable: true);
        await _storeLocation();
      } else {
        String message;
        switch (result) {
          case LocationResult.denied:
            message = 'Location permission denied';
            break;
          case LocationResult.deniedForever:
            message =
                'Location permission is permanently denied. Please enable it in your browser settings.';
            break;
          case LocationResult.servicesDisabled:
            message = 'Location services are disabled.';
            break;
          case LocationResult.error:
          default:
            message = 'Failed to enable location. Please check your settings.';
            break;
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(message),
              duration: const Duration(seconds: 4),
              action: result == LocationResult.deniedForever
                  ? SnackBarAction(
                      label: 'Settings',
                      onPressed: () {
                        // Attempt to open settings (may not work on all browsers)
                        // Geolocator.openAppSettings();
                        // For Web, we can't easily open browser settings, so the message is key.
                      },
                    )
                  : null,
            ),
          );
        }

        // Ensure toggle stays off
        setState(() {
          _isLocationEnabled = false;
        });
      }
    } else {
      setState(() {
        _isLocationEnabled = false;
      });
    }
  }

  Future<void> _storeLocation() async {
    if (_user == null) return;
    try {
      final locationData = await _locationService.getCurrentLocation();
      if (locationData != null &&
          locationData.latitude != null &&
          locationData.longitude != null) {
        final locationsCollection = FirebaseFirestore.instance
            .collection('users')
            .doc(_user!.uid)
            .collection('locations');

        final querySnapshot = await locationsCollection.limit(1).get();

        if (querySnapshot.docs.isNotEmpty) {
          // Update existing document
          await locationsCollection.doc(querySnapshot.docs.first.id).update({
            'latitude': locationData.latitude,
            'longitude': locationData.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          });
          debugPrint('Location updated in doc: ${querySnapshot.docs.first.id}');
        } else {
          // Create new document with random ID
          final docRef = await locationsCollection.add({
            'latitude': locationData.latitude,
            'longitude': locationData.longitude,
            'timestamp': FieldValue.serverTimestamp(),
          });
          debugPrint('Location stored in new doc: ${docRef.id}');
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location stored successfully')),
          );
        }
      } else {
        debugPrint('LocationService: Received null location data');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to get current location.')),
          );
        }
      }
    } catch (e) {
      debugPrint('Error storing location: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error storing location: $e')));
      }
    }
  }

  final List<Map<String, dynamic>> _moods = [
    {
      'icon': Icons.sentiment_very_satisfied,
      'label': 'Great',
      'color': Colors.green,
    },
    {
      'icon': Icons.sentiment_satisfied,
      'label': 'Good',
      'color': Colors.lightGreen,
    },
    {'icon': Icons.sentiment_neutral, 'label': 'Okay', 'color': Colors.amber},
    {
      'icon': Icons.sentiment_dissatisfied,
      'label': 'Bad',
      'color': Colors.orange,
    },
    {
      'icon': Icons.sentiment_very_dissatisfied,
      'label': 'Terrible',
      'color': Colors.red,
    },
  ];

  @override
  void initState() {
    super.initState();
    _user = FirebaseAuth.instance.currentUser;
    _loadTodayMood();
  }

  String _getTodayDocId() {
    final now = DateTime.now();
    return DateFormat('yyyy-MM-dd').format(now);
  }

  Future<void> _loadTodayMood() async {
    if (_user == null) return;

    try {
      final docId = _getTodayDocId();
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('moods')
          .doc(docId)
          .get();

      if (doc.exists && mounted) {
        setState(() {
          _selectedMoodIndex = doc.data()?['moodIndex'] as int?;
        });
      }
    } catch (e) {
      debugPrint('Error loading mood: $e');
    }
  }

  Future<void> _saveMood(int index) async {
    if (_user == null) return;

    setState(() {
      _selectedMoodIndex = index;
    });

    try {
      final docId = _getTodayDocId();
      await FirebaseFirestore.instance
          .collection('users')
          .doc(_user!.uid)
          .collection('moods')
          .doc(docId)
          .set({'moodIndex': index, 'timestamp': FieldValue.serverTimestamp()});

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('You are feeling ${_moods[index]['label']}'),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to save mood: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFFEEF2FF),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'MentalPing',
          style: TextStyle(
            color: Color(0xFF1E3A8A),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF1E3A8A)),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (!context.mounted) return;
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
          ),
          IconButton(
            icon: const Icon(Icons.person, color: Color(0xFF1E3A8A)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const CrisisBanner(),
          Expanded(
            child: KeyboardPadding(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Center(
                  child: Container(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Welcome Section
                        Text(
                          'Welcome, ${_user?.displayName ?? 'Friend'}',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1E3A8A),
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'How are you feeling right now?',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4B5563),
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Location Toggle
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: SwitchListTile(
                            title: const Text(
                              'Enable Location',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            subtitle: const Text(
                              'Allow access to location to track where you feel best',
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xFF6B7280),
                              ),
                            ),
                            value: _isLocationEnabled,
                            onChanged: _toggleLocation,
                            thumbColor: WidgetStateProperty.all(
                              const Color(0xFF1E3A8A),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Mood Picker Card
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Check-in',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF1F2937),
                                ),
                              ),
                              const SizedBox(height: 24),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: List.generate(_moods.length, (index) {
                                  final mood = _moods[index];
                                  final isSelected =
                                      _selectedMoodIndex == index;
                                  return GestureDetector(
                                    onTap: () => _saveMood(index),
                                    child: Column(
                                      children: [
                                        AnimatedContainer(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? mood['color'].withValues(
                                                    alpha: 0.2,
                                                  )
                                                : Colors.grey[100],
                                            shape: BoxShape.circle,
                                            border: isSelected
                                                ? Border.all(
                                                    color: mood['color'],
                                                    width: 2,
                                                  )
                                                : Border.all(
                                                    color: Colors.transparent,
                                                    width: 2,
                                                  ),
                                          ),
                                          child: Icon(
                                            mood['icon'],
                                            size: 32,
                                            color: isSelected
                                                ? mood['color']
                                                : Colors.grey[400],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          mood['label'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: isSelected
                                                ? FontWeight.w600
                                                : FontWeight.normal,
                                            color: isSelected
                                                ? mood['color']
                                                : Colors.grey[500],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 32),
                        const SupportSection(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
