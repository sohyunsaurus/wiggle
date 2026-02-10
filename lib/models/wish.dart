// models/wish.dart
class Wish {
  final int? id;
  final String date;
  final String what; // What do you wish for?
  final String why; // Why is this important?
  final String when; // When do you want this to happen?
  final String where; // Where will this happen?
  final String who; // Who is involved?
  final String how; // How will you make it happen?
  final bool fulfilled;
  final int importance; // 1-5, higher = more important
  final String category; // career, health, relationships, personal, etc.
  final String? reward; // character name that can be unlocked

  Wish({
    this.id,
    required this.date,
    required this.what,
    required this.why,
    required this.when,
    required this.where,
    required this.who,
    required this.how,
    this.fulfilled = false,
    this.importance = 3,
    this.category = 'personal',
    this.reward,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'what': what,
      'why': why,
      'wish_when': when,
      'wish_where': where,
      'wish_who': who,
      'wish_how': how,
      'fulfilled': fulfilled ? 1 : 0,
      'importance': importance,
      'category': category,
      'reward': reward,
    };
  }

  factory Wish.fromMap(Map<String, dynamic> map) {
    return Wish(
      id: map['id'],
      date: map['date'],
      what: map['what'] ?? '',
      why: map['why'] ?? '',
      when: map['wish_when'] ?? '',
      where: map['wish_where'] ?? '',
      who: map['wish_who'] ?? '',
      how: map['wish_how'] ?? '',
      fulfilled: map['fulfilled'] == 1,
      importance: map['importance'] ?? 3,
      category: map['category'] ?? 'personal',
      reward: map['reward'],
    );
  }

  Wish copyWith({
    int? id,
    String? date,
    String? what,
    String? why,
    String? when,
    String? where,
    String? who,
    String? how,
    bool? fulfilled,
    int? importance,
    String? category,
    String? reward,
  }) {
    return Wish(
      id: id ?? this.id,
      date: date ?? this.date,
      what: what ?? this.what,
      why: why ?? this.why,
      when: when ?? this.when,
      where: where ?? this.where,
      who: who ?? this.who,
      how: how ?? this.how,
      fulfilled: fulfilled ?? this.fulfilled,
      importance: importance ?? this.importance,
      category: category ?? this.category,
      reward: reward ?? this.reward,
    );
  }
}
