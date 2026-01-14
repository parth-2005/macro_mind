import 'package:equatable/equatable.dart';

abstract class RewardEvent extends Equatable {
  const RewardEvent();

  @override
  List<Object> get props => [];
}

class LoadRewards extends RewardEvent {
  const LoadRewards();
}

class RedeemReward extends RewardEvent {
  final String rewardId;
  const RedeemReward(this.rewardId);

  @override
  List<Object> get props => [rewardId];
}
