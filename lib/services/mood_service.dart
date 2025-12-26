import 'package:cloud_firestore/cloud_firestore.dart';

class MoodService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Map<String, dynamic>>> getMoodHistory(String uid) async {
    final now = DateTime.now();
    final fourteenDaysAgo = now.subtract(const Duration(days: 14));

    // We want to fetch all moods from 14 days ago until today.
    // Since doc IDs are yyyy-MM-dd, we can use range queries if we had a timestamp field,
    // but we can also just generate the last 14 dates and fetch them in a batch or loop.
    // A better way is to query the subcollection and filter by timestamp if it exists.

    final moodsSnapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('moods')
        .where(
          'timestamp',
          isGreaterThanOrEqualTo: Timestamp.fromDate(fourteenDaysAgo),
        )
        .orderBy('timestamp', descending: false)
        .get();

    return moodsSnapshot.docs.map((doc) {
      final data = doc.data();
      return {
        'date': doc.id,
        'moodIndex': data['moodIndex'],
        'timestamp': data['timestamp'],
      };
    }).toList();
  }
}
