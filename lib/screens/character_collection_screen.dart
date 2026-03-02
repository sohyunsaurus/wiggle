// screens/character_collection_screen.dart
import 'package:flutter/material.dart';
import '../data/database_helper.dart';
import '../models/character.dart';
import '../l10n/app_localizations.dart';
import '../theme/lavender_theme.dart';

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
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: GlassmorphicContainer(
          blur: 15,
          opacity: 0.5,
          color: const Color(0xFFB4A7FF),
          borderRadius: BorderRadius.zero,
          child: AppBar(
            title: Text(
              l10n.myCollection,
              style: getLocalizedTextStyle(
                context,
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : characters.isEmpty
              ? _buildEmptyState(l10n)
              : _buildCharacterGrid(),
    );
  }

  Widget _buildEmptyState(AppLocalizations l10n) {
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
            l10n.noFriendsYet,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.fulfillWishesToUnlock,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.makeWishes),
          ),
        ],
      ),
    );
  }

  Widget _buildCharacterGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        childAspectRatio: 0.9,
        crossAxisSpacing: 3,
        mainAxisSpacing: 3,
      ),
      itemCount: characters.length,
      itemBuilder: (context, index) {
        final character = characters[index];
        return _buildCharacterCard(character, AppLocalizations.of(context)!);
      },
    );
  }

  Widget _buildCharacterCard(Character character, AppLocalizations l10n) {
    return GestureDetector(
      onTap: () => _showCharacterDetails(character, l10n),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: character.isGolden
                    ? Border.all(color: Colors.amber, width: 2)
                    : null,
              ),
              child: Center(
                child: Text(
                  character.assetPath,
                  style: const TextStyle(fontSize: 40),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            character.characterName,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: character.isGolden ? Colors.amber[800] : null,
                ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
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

  void _showCharacterDetails(Character character, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          character.characterName,
          style: getLocalizedTextStyle(
            context,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: character.isGolden
                ? Colors.amber[800]
                : const Color(0xFF5D1049),
          ),
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
            Text('${l10n.collectedOn}: ${character.date}'),
            Text('${l10n.rarity}: ${character.rarity}'),
            Text('${l10n.evolution}: ${character.evolutionStage}'),
            const SizedBox(height: 12),
            Text(l10n.stats, style: Theme.of(context).textTheme.titleSmall),
            Row(
              children: [
                const Icon(Icons.favorite, color: Color(0xFFEF4444), size: 16),
                Text(' ${l10n.happiness}: ${character.happiness}/100'),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.flash_on, color: Color(0xFF3B82F6), size: 16),
                Text(' ${l10n.energy}: ${character.energy}/100'),
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
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        l10n.goldenMessage,
                        style: const TextStyle(
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
            child: Text(l10n.close),
          ),
        ],
      ),
    );
  }
}
