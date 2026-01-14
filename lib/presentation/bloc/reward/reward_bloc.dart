import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/entities/reward_entity.dart';
import 'reward_event.dart';
import 'reward_state.dart';

class RewardBloc extends Bloc<RewardEvent, RewardState> {
  RewardBloc() : super(RewardInitial()) {
    on<LoadRewards>(_onLoadRewards);
    on<RedeemReward>(_onRedeemReward);
  }

  void _onLoadRewards(LoadRewards event, Emitter<RewardState> emit) async {
    emit(RewardLoading());
    // Mocking data for the event
    await Future.delayed(const Duration(milliseconds: 800));
    final mockRewards = [
      const RewardEntity(
        id: '1',
        title: 'Dairy Milk Silk',
        cost: 500,
        imageUrl: 'https://via.placeholder.com/150',
        isDigital: false,
        stock: 50,
      ),
      const RewardEntity(
        id: '2',
        title: 'Lays Magic Masala',
        cost: 200,
        imageUrl: 'https://via.placeholder.com/150',
        isDigital: false,
        stock: 20,
      ),
      const RewardEntity(
        id: '3',
        title: 'Coca Cola 250ml',
        cost: 150,
        imageUrl: 'https://via.placeholder.com/150',
        isDigital: false,
        stock: 30,
      ),
    ];
    emit(RewardLoaded(mockRewards));
  }

  void _onRedeemReward(RedeemReward event, Emitter<RewardState> emit) async {
    emit(RewardRedeeming());
    await Future.delayed(const Duration(seconds: 1));
    emit(RewardRedeemSuccess(event.rewardId));
  }
}
