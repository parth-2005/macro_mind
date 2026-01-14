import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CompatibilityService {
  final FirebaseFirestore _firestore;

  CompatibilityService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Calculates a match percentage based on swiping patterns
  Future<int> getMatchPercentage(String userId, String partnerId) async {
    try {
      // Fetch last 10 swipes for both users
      final userSwipes = await _getRecentSwipes(userId);
      final partnerSwipes = await _getRecentSwipes(partnerId);

      if (userSwipes.isEmpty || partnerSwipes.isEmpty) {
        return _getRandomCompatibility();
      }

      // Simple algorithm: Compare swipedRight values for common cards
      int commonCards = 0;
      int matches = 0;

      for (var cardId in userSwipes.keys) {
        if (partnerSwipes.containsKey(cardId)) {
          commonCards++;
          if (userSwipes[cardId] == partnerSwipes[cardId]) {
            matches++;
          }
        }
      }

      if (commonCards == 0) {
        return _getRandomCompatibility();
      }

      // Calculate percentage, add some "valentine's magic" (base 70%)
      double baseMatch = (matches / commonCards) * 100;
      int finalMatch = (70 + (baseMatch * 0.29)).round();

      return finalMatch.clamp(70, 99);
    } catch (e) {
      debugPrint('[CompatibilityService] Error: $e');
      return _getRandomCompatibility();
    }
  }

  Future<Map<String, bool>> _getRecentSwipes(String uid) async {
    final snapshot = await _firestore
        .collection('interactions')
        .where('userId', isEqualTo: uid)
        .orderBy('timestamp', descending: true)
        .limit(10)
        .get();

    return {
      for (var doc in snapshot.docs)
        doc.data()['cardId'] as String: doc.data()['swipedRight'] as bool,
    };
  }

  int _getRandomCompatibility() {
    // Return a random number between 70 and 99
    return 70 + Random().nextInt(30);
  }
}
