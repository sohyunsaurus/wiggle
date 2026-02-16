// screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluentui_icons/fluentui_icons.dart';
import '../data/database_helper.dart';
import '../l10n/app_localizations.dart';
import '../blocs/language/language_bloc.dart';
import '../blocs/language/language_event.dart';
import '../blocs/language/language_state.dart';
import '../theme/lavender_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(l10n.settings),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info Section
          _buildSectionHeader(l10n.appInfo),
          GlassmorphicContainer(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(20),
            child: _buildInfoCard(l10n),
          ),

          // Language Section
          _buildSectionHeader(l10n.language),
          GlassmorphicContainer(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(4),
            child: _buildLanguageCard(l10n),
          ),

          // Data Management Section
          _buildSectionHeader(l10n.dataManagement),
          GlassmorphicContainer(
            margin: const EdgeInsets.only(bottom: 24),
            padding: const EdgeInsets.all(4),
            child: _buildDataManagementCard(l10n),
          ),

          // Danger Zone
          _buildSectionHeader(l10n.dangerZone, color: const Color(0xFFEF4444)),
          GlassmorphicContainer(
            padding: const EdgeInsets.all(4),
            color: const Color(0xFFEF4444),
            opacity: 0.05,
            child: _buildDangerZoneCard(l10n),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color ?? Theme.of(context).colorScheme.primary,
            ),
      ),
    );
  }

  Widget _buildInfoCard(AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              FluentSystemIcons.ic_fluent_star_filled,
              color: const Color(0xFF9C88FF),
              size: 24,
            ),
            const SizedBox(width: 12),
            Text(
              l10n.appTitle,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          l10n.appDescription,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF6B7280),
              ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            _buildInfoItem(l10n.version, '1.0.0'),
            const SizedBox(width: 24),
            _buildInfoItem(l10n.developer, 'sohyunsaurus'),
          ],
        ),
      ],
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: const Color(0xFF9CA3AF),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageCard(AppLocalizations l10n) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (context, state) {
        String currentLanguage = 'ko';
        if (state is LanguageLoaded) {
          currentLanguage = state.locale.languageCode;
        }

        return Card(
          child: ListTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: Text(l10n.language),
            subtitle:
                Text(currentLanguage == 'ko' ? l10n.korean : l10n.english),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguageDialog(l10n, currentLanguage),
          ),
        );
      },
    );
  }

  void _showLanguageDialog(AppLocalizations l10n, String currentLanguage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.selectLanguage),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: Text(l10n.korean),
              value: 'ko',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context
                      .read<LanguageBloc>()
                      .add(ChangeLanguage(languageCode: value));
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: Text(l10n.english),
              value: 'en',
              groupValue: currentLanguage,
              onChanged: (value) {
                if (value != null) {
                  context
                      .read<LanguageBloc>()
                      .add(ChangeLanguage(languageCode: value));
                  Navigator.pop(context);
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
        ],
      ),
    );
  }

  Widget _buildDataManagementCard(AppLocalizations l10n) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup, color: Colors.blue),
            title: Text(l10n.dataBackup),
            subtitle: Text(l10n.backupDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoonDialog(l10n.dataBackup, l10n);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore, color: Colors.green),
            title: Text(l10n.dataRestore),
            subtitle: Text(l10n.restoreDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoonDialog(l10n.dataRestore, l10n);
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.analytics, color: Colors.orange),
            title: Text(l10n.viewStats),
            subtitle: Text(l10n.statsDescription),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showStatsDialog(l10n);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard(AppLocalizations l10n) {
    return Card(
      color: Colors.red.withValues(alpha: 0.05),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: Text(
              l10n.deleteAllWishes,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(l10n.deleteWishesDescription),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showDeleteWishesDialog(l10n),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.pets_outlined, color: Colors.red),
            title: Text(
              l10n.deleteAllCharacters,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w600),
            ),
            subtitle: Text(l10n.deleteCharactersDescription),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showDeleteCharactersDialog(l10n),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: Text(
              l10n.deleteAllData,
              style: const TextStyle(
                  color: Colors.red, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(l10n.deleteAllDataDescription),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: () => _showDeleteAllDataDialog(l10n),
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature ${l10n.comingSoon}'),
        content: Text(l10n.featureComingSoon),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog(AppLocalizations l10n) async {
    try {
      final db = await DatabaseHelper.instance.database;

      // Get wishes stats
      final wishesResult = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_wishes,
          COUNT(CASE WHEN fulfilled = 1 THEN 1 END) as fulfilled_wishes,
          COUNT(DISTINCT date) as active_days
        FROM wishes
      ''');

      // Get characters stats
      final charactersResult = await db.rawQuery('''
        SELECT 
          COUNT(*) as total_characters,
          COUNT(CASE WHEN is_golden = 1 THEN 1 END) as golden_characters
        FROM character_collection
      ''');

      final wishStats = wishesResult.first;
      final charStats = charactersResult.first;

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(l10n.myStatistics),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow(
                    l10n.totalWishesCount, '${wishStats['total_wishes']}개'),
                _buildStatRow(l10n.fulfilledWishesCount,
                    '${wishStats['fulfilled_wishes']}개'),
                _buildStatRow(
                    l10n.activeDaysCount, '${wishStats['active_days']}일'),
                const Divider(),
                _buildStatRow(l10n.collectedCharacters,
                    '${charStats['total_characters']}개'),
                _buildStatRow(l10n.goldenCharacters,
                    '${charStats['golden_characters']}개'),
                const SizedBox(height: 12),
                if ((wishStats['total_wishes'] as int) > 0)
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .primary
                          .withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${l10n.achievementRate}: ${((wishStats['fulfilled_wishes'] as int) / (wishStats['total_wishes'] as int) * 100).round()}%',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.confirm),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.loadingStatsError}: $e')),
        );
      }
    }
  }

  Widget _buildStatRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  void _showDeleteWishesDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(l10n.deleteAllWishes),
          ],
        ),
        content: Text(
          l10n.deleteWishesConfirm,
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteWishes(l10n);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showDeleteCharactersDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.warning, color: Colors.red),
            const SizedBox(width: 8),
            Text(l10n.deleteAllCharacters),
          ],
        ),
        content: Text(
          l10n.deleteCharactersConfirm,
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCharacters(l10n);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDataDialog(AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.delete_sweep, color: Colors.red),
            const SizedBox(width: 8),
            Text(l10n.deleteAllData),
          ],
        ),
        content: Text(
          l10n.deleteAllDataConfirm,
          style: const TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalConfirmationDialog(l10n);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmationDialog(AppLocalizations l10n) {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.finalConfirmation),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.typeDeleteToConfirm,
              style: const TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: InputDecoration(
                hintText: l10n.deleteText,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          StatefulBuilder(
            builder: (context, setState) => ElevatedButton(
              onPressed: confirmController.text == l10n.deleteText
                  ? () {
                      Navigator.pop(context);
                      _deleteAllData(l10n);
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: Text(l10n.deleteAllData),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteWishes(AppLocalizations l10n) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('wishes');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.allWishesDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.deletionError}: $e')),
        );
      }
    }
  }

  Future<void> _deleteCharacters(AppLocalizations l10n) async {
    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('character_collection');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.allCharactersDeleted),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.deletionError}: $e')),
        );
      }
    }
  }

  Future<void> _deleteAllData(AppLocalizations l10n) async {
    try {
      await DatabaseHelper.instance.resetDatabase();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(l10n.allDataDeleted),
            backgroundColor: Colors.green,
          ),
        );

        // Show restart recommendation dialog
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('✅ 완료'),
                content: Text(l10n.restartRecommended),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context); // Close settings screen
                    },
                    child: Text(l10n.confirm),
                  ),
                ],
              ),
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${l10n.deletionError}: $e')),
        );
      }
    }
  }
}
