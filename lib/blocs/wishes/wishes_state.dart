// blocs/wishes/wishes_state.dart
import 'package:equatable/equatable.dart';
import '../../models/wish.dart';
import '../../models/character.dart';

abstract class WishesState extends Equatable {
  const WishesState();

  @override
  List<Object?> get props => [];
}

class WishesInitial extends WishesState {}

class WishesLoading extends WishesState {}

class WishesLoaded extends WishesState {
  final List<Wish> wishes;
  final int fulfilledCount;
  final int totalCount;
  final int currentStreak;
  final bool canUnlockCharacter;

  const WishesLoaded({
    required this.wishes,
    required this.fulfilledCount,
    required this.totalCount,
    required this.currentStreak,
    required this.canUnlockCharacter,
  });

  @override
  List<Object?> get props =>
      [wishes, fulfilledCount, totalCount, currentStreak, canUnlockCharacter];
}

class WishFulfilled extends WishesState {
  final List<Wish> wishes;
  final Character? unlockedCharacter;
  final int fulfilledCount;
  final int totalCount;
  final int currentStreak;
  final bool allWishesFulfilled;

  const WishFulfilled({
    required this.wishes,
    this.unlockedCharacter,
    required this.fulfilledCount,
    required this.totalCount,
    required this.currentStreak,
    required this.allWishesFulfilled,
  });

  @override
  List<Object?> get props => [
        wishes,
        unlockedCharacter,
        fulfilledCount,
        totalCount,
        currentStreak,
        allWishesFulfilled
      ];
}

class WishesError extends WishesState {
  final String message;

  const WishesError({required this.message});

  @override
  List<Object?> get props => [message];
}
