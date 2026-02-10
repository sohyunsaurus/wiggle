// screens/character_collection_screen.dart
import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/character.dart';

class CharacterCollectionScreen extends StatefulWidget {
  const CharacterCollectionScreen({super.key});

  @override
  State<CharacterCollectionScreen> createState() =>
      _CharacterCollectionScreenState();
}

class _CharacterCollectionScreenState extends State<CharacterCollectionScreen> {
  List<Character> characters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCharacters();
  }

  Future<void> _loadCharacters() async {
    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query(
        'character_collection',
        orderBy: 'date DESC',
      );

      setState(() {
        characters = result.map((map) => Character.fromMap(map)).toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tamagotchi Collection ✨'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : characters.isEmpty
              ? _buildEmptyState()
              : _buildCharacterGrid(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.pets_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No tamagotchi friends yet',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Fulfill your wishes to unlock adorable companions! ✨',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Make Wishes'),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return _buildCharacterCard(character);
      },
    );
  }

  Widget _buildCharacterCard(Character character) {
    return GestureDetector(
      onTap: () => _showCharacterDetails(character),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: character.isGolden
              ? LinearGradient(
                  colors: [
                    Colors.amber.withValues(alpha: 0.3),
                    Colors.orange.withValues(alpha: 0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
          border: character.isGolden
              ? Border.all(color: Colors.amber, width: 2)
              : null,
          boxShadow: character.isGolden
              ? [
                  BoxShadow(
                    color: Colors.amber.withValues(alpha: 0.4),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Card(
          elevation: character.isGolden ? 8 : 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Character avatar placeholder
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: _getRarityColor(character.rarity)
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _getRarityColor(character.rarity)
                            .withValues(alpha: 0.3),
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            character.assetPath,
                            style: const TextStyle(fontSize: 48),
                          ),
                          if (character.isGolden) ...[
                            const SizedBox(height: 8),
                            const Icon(
                              Icons.star,
                              color: Colors.amber,
                              size: 24,
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  character.characterName,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: character.isGolden ? Colors.amber[800] : null,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  character.date,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatIndicator(
                      Icons.favorite,
                      character.happiness,
                      Colors.red,
                    ),
                    const SizedBox(width: 8),
                    _buildStatIndicator(
                      Icons.flash_on,
                      character.energy,
                      Colors.blue,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatIndicator(IconData icon, int value, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 2),
        Text(
          '$value',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      ],
    );
  }

  Color _getRarityColor(String rarity) {
    switch (rarity) {
      case 'legendary':
        return Colors.purple;
      case 'epic':
        return Colors.orange;
      case 'rare':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showCharacterDetails(Character character) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Expanded(
              child: Text(character.characterName),
            ),
            if (character.isGolden) const Icon(Icons.star, color: Colors.amber),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                character.assetPath,
                style: const TextStyle(fontSize: 64),
              ),
            ),
            const SizedBox(height: 16),
            Text('Collected: ${character.date}'),
            Text('Rarity: ${character.rarity}'),
            Text('Evolution: ${character.evolutionStage}'),
            const SizedBox(height: 12),
            Text('Stats:', style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: [
                const Icon(Icons.favorite, color: Colors.red, size: 16),
                Text(' Happiness: ${character.happiness}/100'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.flash_on, color: Colors.blue, size: 16),
                Text(' Energy: ${character.energy}/100'),
              ],
            ),
            if (character.isGolden) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.amber),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This companion glows golden because all related wishes have been fulfilled! ✨',
                        style: TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            if (character.description.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(character.description),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
