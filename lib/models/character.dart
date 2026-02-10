// models/character.dart
class Character {
  final int? id;
  final String date;
  final String characterName;
  final String assetPath;
  final String rarity; // common, rare, epic, legendary
  final String description;
  final bool isUnlocked;
  final bool isGolden; // true when all wishes for this character are fulfilled
  final int happiness; // 0-100
  final int energy; // 0-100
  final String evolutionStage; // baby, adult, evolved
  final DateTime? lastInteraction;
  final List<String>
      fulfilledWishes; // List of wish IDs that made this character glow

  Character({
    this.id,
    required this.date,
    required this.characterName,
    required this.assetPath,
    this.rarity = 'common',
    this.description = '',
    this.isUnlocked = false,
    this.isGolden = false,
    this.happiness = 50,
    this.energy = 50,
    this.evolutionStage = 'baby',
    this.lastInteraction,
    this.fulfilledWishes = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'character_name': characterName,
      'asset_path': assetPath,
      'rarity': rarity,
      'description': description,
      'is_unlocked': isUnlocked ? 1 : 0,
      'is_golden': isGolden ? 1 : 0,
      'happiness': happiness,
      'energy': energy,
      'evolution_stage': evolutionStage,
      'last_interaction': lastInteraction?.toIso8601String(),
      'fulfilled_wishes': fulfilledWishes.join(','),
    };
  }

  factory Character.fromMap(Map<String, dynamic> map) {
    return Character(
      id: map['id'],
      date: map['date'],
      characterName: map['character_name'],
      assetPath: map['asset_path'],
      rarity: map['rarity'] ?? 'common',
      description: map['description'] ?? '',
      isUnlocked: map['is_unlocked'] == 1,
      isGolden: map['is_golden'] == 1,
      happiness: map['happiness'] ?? 50,
      energy: map['energy'] ?? 50,
      evolutionStage: map['evolution_stage'] ?? 'baby',
      lastInteraction: map['last_interaction'] != null
          ? DateTime.parse(map['last_interaction'])
          : null,
      fulfilledWishes: map['fulfilled_wishes'] != null
          ? (map['fulfilled_wishes'] as String)
              .split(',')
              .where((s) => s.isNotEmpty)
              .toList()
          : [],
    );
  }

  Character copyWith({
    int? id,
    String? date,
    String? characterName,
    String? assetPath,
    String? rarity,
    String? description,
    bool? isUnlocked,
    bool? isGolden,
    int? happiness,
    int? energy,
    String? evolutionStage,
    DateTime? lastInteraction,
    List<String>? fulfilledWishes,
  }) {
    return Character(
      id: id ?? this.id,
      date: date ?? this.date,
      characterName: characterName ?? this.characterName,
      assetPath: assetPath ?? this.assetPath,
      rarity: rarity ?? this.rarity,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isGolden: isGolden ?? this.isGolden,
      happiness: happiness ?? this.happiness,
      energy: energy ?? this.energy,
      evolutionStage: evolutionStage ?? this.evolutionStage,
      lastInteraction: lastInteraction ?? this.lastInteraction,
      fulfilledWishes: fulfilledWishes ?? this.fulfilledWishes,
    );
  }

  // Helper methods
  bool get needsAttention => happiness < 30 || energy < 30;
  bool get isHappy => happiness > 70;
  bool get isEnergetic => energy > 70;

  String get statusEmoji {
    if (isGolden) return '✨';
    if (needsAttention) return '😢';
    if (isHappy && isEnergetic) return '😊';
    if (isHappy) return '😌';
    if (isEnergetic) return '😄';
    return '😐';
  }
}
