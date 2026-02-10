// blocs/wishes/wishes_event.dart
import 'package:equatable/equatable.dart';
import '../../models/wish.dart';

abstract class WishesEvent extends Equatable {
  const WishesEvent();

  @override
  List<Object?> get props => [];
}

class LoadTodayWishes extends WishesEvent {}

class AddWish extends WishesEvent {
  final Wish wish;

  const AddWish({required this.wish});

  @override
  List<Object?> get props => [wish];
}

class FulfillWish extends WishesEvent {
  final int wishId;

  const FulfillWish({required this.wishId});

  @override
  List<Object?> get props => [wishId];
}

class UnfulfillWish extends WishesEvent {
  final int wishId;

  const UnfulfillWish({required this.wishId});

  @override
  List<Object?> get props => [wishId];
}

class DeleteWish extends WishesEvent {
  final int wishId;

  const DeleteWish({required this.wishId});

  @override
  List<Object?> get props => [wishId];
}

class UpdateWish extends WishesEvent {
  final Wish wish;

  const UpdateWish({required this.wish});

  @override
  List<Object?> get props => [wish];
}
