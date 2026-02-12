// screens/settings_screen.dart
import 'package:flutter/material.dart';
import '../data/database_helper.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('설정 ⚙️'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // App Info Section
          _buildSectionHeader('앱 정보'),
          _buildInfoCard(),

          const SizedBox(height: 24),

          // Data Management Section
          _buildSectionHeader('데이터 관리'),
          _buildDataManagementCard(),

          const SizedBox(height: 24),

          // Danger Zone
          _buildSectionHeader('위험 구역', color: Colors.red),
          _buildDangerZoneCard(),
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

  Widget _buildInfoCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary,
                  size: 24,
                ),
                const SizedBox(width: 12),
                Text(
                  'Make a Wish ✨',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '매일 소원을 만들고 귀여운 타마고치 친구들을 모아보세요!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem('버전', '1.0.0'),
                const SizedBox(width: 24),
                _buildInfoItem('개발자', 'sohyunsaurus'),
              ],
            ),
          ],
        ),
      ),
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
            color: Colors.grey[600],
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

  Widget _buildDataManagementCard() {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.backup, color: Colors.blue),
            title: const Text('데이터 백업'),
            subtitle: const Text('소원과 캐릭터 데이터를 백업합니다'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoonDialog('데이터 백업');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.restore, color: Colors.green),
            title: const Text('데이터 복원'),
            subtitle: const Text('백업된 데이터를 복원합니다'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showComingSoonDialog('데이터 복원');
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.analytics, color: Colors.orange),
            title: const Text('통계 보기'),
            subtitle: const Text('상세한 소원 달성 통계를 확인합니다'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              _showStatsDialog();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDangerZoneCard() {
    return Card(
      color: Colors.red.withValues(alpha: 0.05),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.delete_forever, color: Colors.red),
            title: const Text(
              '모든 소원 삭제',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('모든 소원 기록을 삭제합니다 (복구 불가능)'),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: _showDeleteWishesDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.pets_outlined, color: Colors.red),
            title: const Text(
              '모든 캐릭터 삭제',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text('모든 타마고치 컬렉션을 삭제합니다 (복구 불가능)'),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: _showDeleteCharactersDialog,
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.delete_sweep, color: Colors.red),
            title: const Text(
              '모든 데이터 삭제',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
            subtitle: const Text('앱의 모든 데이터를 완전히 삭제합니다 (복구 불가능)'),
            trailing: const Icon(Icons.chevron_right, color: Colors.red),
            onTap: _showDeleteAllDataDialog,
          ),
        ],
      ),
    );
  }

  void _showComingSoonDialog(String feature) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$feature 🚧'),
        content: const Text('이 기능은 곧 추가될 예정입니다!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('확인'),
          ),
        ],
      ),
    );
  }

  void _showStatsDialog() async {
    setState(() {
      _isLoading = true;
    });

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

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('📊 나의 통계'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildStatRow('총 소원 개수', '${wishStats['total_wishes']}개'),
                _buildStatRow('이뤄진 소원', '${wishStats['fulfilled_wishes']}개'),
                _buildStatRow('활동일', '${wishStats['active_days']}일'),
                const Divider(),
                _buildStatRow('모은 캐릭터', '${charStats['total_characters']}개'),
                _buildStatRow('황금 캐릭터', '${charStats['golden_characters']}개'),
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
                            '달성률: ${((wishStats['fulfilled_wishes'] as int) / (wishStats['total_wishes'] as int) * 100).round()}%',
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
                child: const Text('확인'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('통계를 불러오는 중 오류가 발생했습니다: $e')),
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

  void _showDeleteWishesDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('소원 삭제 확인'),
          ],
        ),
        content: const Text(
          '모든 소원 기록을 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteWishes();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCharactersDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('캐릭터 삭제 확인'),
          ],
        ),
        content: const Text(
          '모든 타마고치 캐릭터를 삭제하시겠습니까?\n\n이 작업은 되돌릴 수 없습니다.',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _deleteCharacters();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showDeleteAllDataDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.delete_sweep, color: Colors.red),
            SizedBox(width: 8),
            Text('전체 데이터 삭제'),
          ],
        ),
        content: const Text(
          '정말로 모든 데이터를 삭제하시겠습니까?\n\n• 모든 소원 기록\n• 모든 타마고치 캐릭터\n• 모든 설정\n\n이 작업은 절대 되돌릴 수 없습니다!',
          style: TextStyle(height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              _showFinalConfirmationDialog();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('삭제'),
          ),
        ],
      ),
    );
  }

  void _showFinalConfirmationDialog() {
    final TextEditingController confirmController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('⚠️ 최종 확인'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '정말로 모든 데이터를 삭제하려면 아래에 "삭제"를 입력하세요:',
              style: TextStyle(height: 1.5),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: confirmController,
              decoration: const InputDecoration(
                hintText: '삭제',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('취소'),
          ),
          StatefulBuilder(
            builder: (context, setState) => ElevatedButton(
              onPressed: confirmController.text == '삭제'
                  ? () {
                      Navigator.pop(context);
                      _deleteAllData();
                    }
                  : null,
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('모든 데이터 삭제'),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteWishes() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('wishes');

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('모든 소원이 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  Future<void> _deleteCharacters() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = await DatabaseHelper.instance.database;
      await db.delete('character_collection');

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('모든 캐릭터가 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }

  Future<void> _deleteAllData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      await DatabaseHelper.instance.resetDatabase();

      setState(() {
        _isLoading = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('모든 데이터가 삭제되었습니다'),
            backgroundColor: Colors.green,
          ),
        );

        // 잠시 후 앱 재시작을 권장하는 다이얼로그
        Future.delayed(const Duration(seconds: 1), () {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => AlertDialog(
                title: const Text('✅ 완료'),
                content: const Text('모든 데이터가 삭제되었습니다.\n앱을 재시작하는 것을 권장합니다.'),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context); // 설정 화면 닫기
                    },
                    child: const Text('확인'),
                  ),
                ],
              ),
            );
          }
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('삭제 중 오류가 발생했습니다: $e')),
        );
      }
    }
  }
}
