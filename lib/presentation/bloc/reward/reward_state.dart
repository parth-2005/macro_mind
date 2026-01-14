import 'package:equatable/equatable.dart';
import '../../../domain/entities/reward_entity.dart';

abstract class RewardState extends Equatable {
  const RewardState();

  @override
  List<Object?> get props => [];
}

class RewardInitial extends RewardState {}

class RewardLoading extends RewardState {}

class RewardLoaded extends RewardState {
  final List<RewardEntity> rewards;
  const RewardLoaded(this.rewards);

  @override
  List<Object?> get props => [rewards];
}

class RewardRedeeming extends RewardState {}

class RewardRedeemSuccess extends RewardState {
  final String rewardId;
  const RewardRedeemSuccess(this.rewardId);

  @override
  List<Object?> get props => [rewardId];
}

class RewardError extends RewardState {
  final String message;
  const RewardError(this.message);

  @override
  List<Object?> get props => [message];
}
