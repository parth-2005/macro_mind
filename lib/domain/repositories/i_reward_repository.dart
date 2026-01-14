import '../entities/reward_entity.dart';

abstract class IRewardRepository {
  /// Fetches all available rewards from Firestore
  Future<List<RewardEntity>> getRewards();

  /// Redeems a reward for the current user
  /// Returns nothing but throws an exception if redemption fails (insufficient points, out of stock, etc.)
  Future<void> redeemReward(String rewardId);
}
