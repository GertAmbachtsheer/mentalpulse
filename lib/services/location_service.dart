import 'package:location/location.dart';
import 'package:flutter/foundation.dart';

enum LocationResult { granted, denied, deniedForever, servicesDisabled, error }

class LocationService {
  final Location _location = Location();

  Future<LocationResult> requestPermission() async {
    try {
      // On Web, explicit permission checks/requests often fail with the location package.
      // We will skip them and rely on getLocation() to trigger the prompt.
      if (kIsWeb) {
        try {
          final data = await _location.getLocation();
          _lastData = data;
          return LocationResult.granted;
        } catch (e) {
          debugPrint('LocationService: Web getLocation failed: $e');
          return LocationResult.denied;
        }
      }

      // 1. Check if location services are enabled
      bool serviceEnabled = await _location.serviceEnabled();
      if (!serviceEnabled) {
        serviceEnabled = await _location.requestService();
        if (!serviceEnabled) {
          debugPrint('LocationService: Location services are disabled.');
          return LocationResult.servicesDisabled;
        }
      }

      // 2. Check current permission status
      PermissionStatus permission = await _location.hasPermission();
      debugPrint('LocationService: Initial permission status: $permission');

      if (permission == PermissionStatus.denied) {
        permission = await _location.requestPermission();
        debugPrint('LocationService: Permission after request: $permission');
        if (permission == PermissionStatus.denied) {
          return LocationResult.denied;
        }
      }

      if (permission == PermissionStatus.deniedForever) {
        debugPrint('LocationService: Permission denied forever');
        return LocationResult.deniedForever;
      }

      if (permission == PermissionStatus.granted ||
          permission == PermissionStatus.grantedLimited) {
        return LocationResult.granted;
      }

      return LocationResult.error;
    } catch (e) {
      debugPrint('LocationService: Error checking/requesting permission: $e');
      return LocationResult.error;
    }
  }

  Future<bool> enableBackgroundMode({bool enable = true}) async {
    if (kIsWeb) {
      debugPrint('LocationService: Background mode not supported on Web');
      return false;
    }
    try {
      return await _location.enableBackgroundMode(enable: enable);
    } catch (e) {
      debugPrint('LocationService: Error changing background mode: $e');
      return false;
    }
  }

  Future<bool> changeSettings({
    LocationAccuracy accuracy = LocationAccuracy.high,
    int interval = 1000,
    double distanceFilter = 0,
  }) async {
    try {
      return await _location.changeSettings(
        accuracy: accuracy,
        interval: interval,
        distanceFilter: distanceFilter,
      );
    } catch (e) {
      debugPrint('LocationService: Error changing settings: $e');
      return false;
    }
  }

  LocationData? _lastData;

  Future<LocationData?> getCurrentLocation() async {
    try {
      // If we just got it via permission check (especially on Web), return that.
      if (_lastData != null) {
        final data = _lastData;
        _lastData = null; // Clear it for next time
        return data;
      }
      return await _location.getLocation();
    } catch (e) {
      debugPrint('LocationService: Error getting location: $e');
      return null;
    }
  }
}
