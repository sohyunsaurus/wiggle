// data/character_data.dart
import '../models/character.dart';

class CharacterData {
  static final List<Character> availableCharacters = [
    // Common Characters (easy to get)
    Character(
      characterName: 'Sunny Chick',
      assetPath: '🐣',
      rarity: 'common',
      description: 'A cheerful little chick that loves mornings!',
      date: '',
    ),
    Character(
      characterName: 'Sleepy Slime',
      assetPath: '💤',
      rarity: 'common',
      description: 'A drowsy slime that appreciates good rest.',
      date: '',
    ),
    Character(
      characterName: 'Happy Sprout',
      assetPath: '🌱',
      rarity: 'common',
      description: 'A tiny plant friend growing stronger each day.',
      date: '',
    ),
    Character(
      characterName: 'Cozy Cat',
      assetPath: '🐱',
      rarity: 'common',
      description: 'A content kitty that purrs with satisfaction.',
      date: '',
    ),

    // Rare Characters (need consistency)
    Character(
      characterName: 'Mystic Owl',
      assetPath: '🦉',
      rarity: 'rare',
      description: 'A wise owl that appears to dedicated souls.',
      date: '',
    ),
    Character(
      characterName: 'Crystal Fox',
      assetPath: '🦊',
      rarity: 'rare',
      description: 'A magical fox with shimmering fur.',
      date: '',
    ),
    Character(
      characterName: 'Star Bunny',
      assetPath: '🐰',
      rarity: 'rare',
      description: 'A celestial rabbit that hops among stars.',
      date: '',
    ),

    // Epic Characters (weekly streaks)
    Character(
      characterName: 'Phoenix Flame',
      assetPath: '🔥',
      rarity: 'epic',
      description: 'A legendary bird reborn from dedication.',
      date: '',
    ),
    Character(
      characterName: 'Ocean Spirit',
      assetPath: '🌊',
      rarity: 'epic',
      description: 'A serene guardian of the deep waters.',
      date: '',
    ),

    // Legendary Characters (monthly achievements)
    Character(
      characterName: 'Cosmic Dragon',
      assetPath: '🐉',
      rarity: 'legendary',
      description: 'The ultimate companion for true masters.',
      date: '',
    ),
  ];

  static Character getRandomCharacterByRarity(String rarity) {
    final characters =
        availableCharacters.where((c) => c.rarity == rarity).toList();
    if (characters.isEmpty) return availableCharacters.first;
    characters.shuffle();
    return characters.first;
  }

  static String determineRarityByStreak(int streak) {
    if (streak >= 30) return 'legendary';
    if (streak >= 7) return 'epic';
    if (streak >= 3) return 'rare';
    return 'common';
  }
}
