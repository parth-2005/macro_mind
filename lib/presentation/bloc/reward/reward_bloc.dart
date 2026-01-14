import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/i_reward_repository.dart';
import 'reward_event.dart';
import 'reward_state.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  final IRewardRepository _rewardRepository;

  RewardBloc({required IRewardRepository rewardRepository})
    : _rewardRepository = rewardRepository,
      super(RewardInitial()) {
    on<LoadRewards>(_onLoadRewards);
    on<RedeemReward>(_onRedeemReward);
  }

  void _onLoadRewards(LoadRewards event, Emitter<RewardState> emit) async {
    emit(RewardLoading());
    try {
      final rewards = await _rewardRepository.getRewards();
      emit(RewardLoaded(rewards));
    } catch (e) {
      emit(RewardError(e.toString()));
    }
  }

  void _onRedeemReward(RedeemReward event, Emitter<RewardState> emit) async {
    emit(RewardRedeeming());
    try {
      await _rewardRepository.redeemReward(event.rewardId);
      emit(RewardRedeemSuccess(event.rewardId));
    } catch (e) {
      emit(RewardError(e.toString()));
    }
  }
}
