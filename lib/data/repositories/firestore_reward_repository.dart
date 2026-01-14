import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/reward_entity.dart';
import '../../domain/repositories/i_reward_repository.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../models/reward_model.dart';

class FirestoreRewardRepository implements IRewardRepository {
  final FirebaseFirestore _firestore;
  final IAuthRepository _authRepository;

  FirestoreRewardRepository({
    FirebaseFirestore? firestore,
    required IAuthRepository authRepository,
  }) : _firestore = firestore ?? FirebaseFirestore.instance,
       _authRepository = authRepository;

  @override
  Future<List<RewardEntity>> getRewards() async {
    try {
      debugPrint('[FirestoreRewardRepository] Fetching rewards...');
      final snapshot = await _firestore.collection('rewards').get();

      final rewards = snapshot.docs
          .map((doc) {
            try {
              final data = doc.data();
              data['id'] = doc.id;
              return RewardModel.fromJson(data);
            } catch (e) {
              debugPrint(
                '[FirestoreRewardRepository] Error parsing reward ${doc.id}: $e',
              );
              return null;
            }
          })
          .whereType<RewardModel>()
          .toList();

      debugPrint(
        '[FirestoreRewardRepository] Fetched ${rewards.length} rewards',
      );
      return rewards;
    } catch (e) {
      debugPrint('[FirestoreRewardRepository] Error fetching rewards: $e');
      throw Exception('Failed to load rewards: $e');
    }
  }

  @override
  Future<void> redeemReward(String rewardId) async {
    final user = _authRepository.currentUser;
    if (user == null) {
      throw Exception('User must be logged in to redeem rewards');
    }

    try {
      debugPrint(
        '[FirestoreRewardRepository] Redeeming reward: $rewardId for user: ${user.id}',
      );

      return await _firestore.runTransaction((transaction) async {
        // 1. Get Reward details
        final rewardRef = _firestore.collection('rewards').doc(rewardId);
        final rewardDoc = await transaction.get(rewardRef);

        if (!rewardDoc.exists) throw Exception('Reward not found');

        final rewardData = rewardDoc.data()!;
        final cost = (rewardData['cost'] as num).toInt();
        final stock = (rewardData['stock'] as num).toInt();

        if (stock <= 0) throw Exception('Reward out of stock');

        // 2. Get User details
        final userRef = _firestore.collection('users').doc(user.id);
        final userDoc = await transaction.get(userRef);

        if (!userDoc.exists)
          throw Exception('User record not found in Firestore');

        final userPoints = (userDoc.data()?['points'] as num?)?.toInt() ?? 0;

        if (userPoints < cost) {
          throw Exception('Insufficient points (Need $cost, have $userPoints)');
        }

        // 3. Update stock and points
        transaction.update(rewardRef, {'stock': stock - 1});
        transaction.update(userRef, {'points': userPoints - cost});

        // 4. Record redemption
        final redemptionRef = _firestore.collection('redemptions').doc();
        transaction.set(redemptionRef, {
          'userId': user.id,
          'rewardId': rewardId,
          'title': rewardData['title'],
          'cost': cost,
          'redeemedAt': FieldValue.serverTimestamp(),
          'status': 'completed',
        });
      });
    } catch (e) {
      debugPrint('[FirestoreRewardRepository] Error redeeming reward: $e');
      rethrow;
    }
  }
}
