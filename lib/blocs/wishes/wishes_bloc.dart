// blocs/wishes/wishes_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../data/database_helper.dart';
import '../../data/character_data.dart';
import '../../models/character.dart';
import '../../models/wish.dart';
import 'wishes_event.dart';
import 'wishes_state.dart';

class WishesBloc extends Bloc<WishesEvent, WishesState> {
  WishesBloc() : super(WishesInitial()) {
    on<LoadTodayWishes>(_onLoadTodayWishes);
    on<AddWish>(_onAddWish);
    on<FulfillWish>(_onFulfillWish);
    on<UnfulfillWish>(_onUnfulfillWish);
    on<DeleteWish>(_onDeleteWish);
    on<UpdateWish>(_onUpdateWish);
  }

  Future<void> _onLoadTodayWishes(
      LoadTodayWishes event, Emitter<WishesState> emit) async {
    emit(WishesLoading());

    try {
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final db = await DatabaseHelper.instance.database;

      // Load today's wishes
      final result = await db.query(
        'wishes',
        where: 'date = ?',
        whereArgs: [today],
        orderBy: 'importance DESC, id ASC',
      );

      final wishes = result.map((map) => Wish.fromMap(map)).toList();

      // If no wishes for today, create a default one
      if (wishes.isEmpty) {
        await _createDefaultWish(today);
        add(LoadTodayWishes()); // Reload after creating default
        return;
      }

      final fulfilledCount = wishes.where((wish) => wish.fulfilled).length;
      final totalCount = wishes.length;
      final streak = await _getCurrentStreak();
      final canUnlock = fulfilledCount == totalCount && totalCount > 0;

      emit(WishesLoaded(
        wishes: wishes,
        fulfilledCount: fulfilledCount,
        totalCount: totalCount,
        currentStreak: streak,
        canUnlockCharacter: canUnlock,
      ));
    } catch (e) {
      emit(WishesError(message: e.toString()));
    }
  }

  Future<void> _onAddWish(AddWish event, Emitter<WishesState> emit) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.insert('wishes', event.wish.toMap());
      add(LoadTodayWishes());
    } catch (e) {
      emit(WishesError(message: e.toString()));
    }
  }

  Future<void> _onFulfillWish(
      FulfillWish event, Emitter<WishesState> emit) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'wishes',
        {'fulfilled': 1},
        where: 'id = ?',
        whereArgs: [event.wishId],
      );

      // Check if this fulfillment unlocks a character
      final today = DateFormat('yyyy-MM-dd').format(DateTime.now());
      final wishes = await db.query(
        'wishes',
        where: 'date = ?',
        whereArgs: [today],
      );

      final wishList = wishes.map((map) => Wish.fromMap(map)).toList();
      final fulfilledCount = wishList.where((wish) => wish.fulfilled).length;
      final totalCount = wishList.length;
      final streak = await _getCurrentStreak();

      Character? unlockedCharacter;
      bool allFulfilled = false;

      // If all wishes are fulfilled, unlock today's character
      if (fulfilledCount == totalCount && totalCount > 0) {
        unlockedCharacter = await _unlockTodaysCharacter(today);
        allFulfilled = true;
      }

      emit(WishFulfilled(
        wishes: wishList,
        unlockedCharacter: unlockedCharacter,
        fulfilledCount: fulfilledCount,
        totalCount: totalCount,
        currentStreak: streak,
        allWishesFulfilled: allFulfilled,
      ));
    } catch (e) {
      emit(WishesError(message: e.toString()));
    }
  }

  Future<void> _onUnfulfillWish(
      UnfulfillWish event, Emitter<WishesState> emit) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'wishes',
        {'fulfilled': 0},
        where: 'id = ?',
        whereArgs: [event.wishId],
      );
      add(LoadTodayWishes());
    } catch (e) {
      emit(WishesError(message: e.toString()));
    }
  }

  Future<void> _onDeleteWish(
      DeleteWish event, Emitter<WishesState> emit) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete(
        'wishes',
        where: 'id = ?',
        whereArgs: [event.wishId],
      );
      add(LoadTodayWishes());
    } catch (e) {
      emit(WishesError(message: e.toString()));
    }
  }

  Future<void> _onUpdateWish(
      UpdateWish event, Emitter<WishesState> emit) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.update(
        'wishes',
        event.wish.toMap(),
        where: 'id = ?',
        whereArgs: [event.wish.id],
      );
      add(LoadTodayWishes());
    } catch (e) {
      emit(WishesError(message: e.toString()));
    }
  }

  Future<void> _createDefaultWish(String date) async {
    final db = await DatabaseHelper.instance.database;
    final defaultWish = Wish(
      date: date,
      what: 'Make my first wish come true ✨',
      why: 'To start my magical journey of manifestation',
      when: 'Today',
      where: 'In my heart and mind',
      who: 'Myself and the universe',
      how: 'With positive intention and action',
      importance: 5,
      category: 'personal',
    );

    await db.insert('wishes', defaultWish.toMap());
  }

  Future<Character?> _unlockTodaysCharacter(String date) async {
    final db = await DatabaseHelper.instance.database;

    // Check if character already exists for today
    final existing = await db.query(
      'character_collection',
      where: 'date = ?',
      whereArgs: [date],
    );

    if (existing.isNotEmpty) {
      return Character.fromMap(existing.first);
    }

    // Create new character for today
    final rarity =
        CharacterData.determineRarityByStreak(await _getCurrentStreak());
    final characterTemplate = CharacterData.getRandomCharacterByRarity(rarity);
    final character = Character(
      date: date,
      characterName: characterTemplate.characterName,
      assetPath: characterTemplate.assetPath,
      rarity: characterTemplate.rarity,
      description: characterTemplate.description,
      isUnlocked: true,
      happiness: 100, // Start with full happiness when unlocked
      energy: 100,
    );

    await db.insert('character_collection', character.toMap());
    return character;
  }

  Future<int> _getCurrentStreak() async {
    final db = await DatabaseHelper.instance.database;
    final today = DateTime.now();
    int streak = 0;

    for (int i = 0; i < 365; i++) {
      final checkDate = today.subtract(Duration(days: i));
      final dateStr = DateFormat('yyyy-MM-dd').format(checkDate);

      final wishes = await db.query(
        'wishes',
        where: 'date = ?',
        whereArgs: [dateStr],
      );

      if (wishes.isEmpty) break;

      final wishList = wishes.map((map) => Wish.fromMap(map)).toList();
      final fulfilledCount = wishList.where((wish) => wish.fulfilled).length;
      final totalCount = wishList.length;

      if (fulfilledCount == totalCount && totalCount > 0) {
        streak++;
      } else {
        break;
      }
    }

    return streak;
  }
}
