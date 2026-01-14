import 'package:equatable/equatable.dart';

/// Represents items users can buy with points
class RewardEntity extends Equatable {
  final String id;
  final String title;
  final int cost;
  final String imageUrl;
  final bool isDigital;
  final int stock;

  const RewardEntity({
    required this.id,
    required this.title,
    required this.cost,
    required this.imageUrl,
    required this.isDigital,
    required this.stock,
  });

  @override
  List<Object?> get props => [id, title, cost, imageUrl, isDigital, stock];
}
