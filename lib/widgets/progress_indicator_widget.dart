// widgets/progress_indicator_widget.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/lavender_theme.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final int completed;
  final int total;
  final int streak;
  final bool canUnlock;

  const ProgressIndicatorWidget({
    super.key,
    required this.completed,
    required this.total,
    required this.streak,
    required this.canUnlock,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final progress = total > 0 ? completed / total : 0.0;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: canUnlock
              ? [Colors.purple[100]!, Colors.purple[50]!]
              : [Colors.blue[50]!, Colors.indigo[50]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.todayProgress,
                    style: getLocalizedTextStyle(
                      context,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$completed / $total ${l10n.completed}',
                    style: getLocalizedTextStyle(
                      context,
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_fire_department,
                          color: Colors.orange, size: 20),
                      const SizedBox(width: 4),
                      Text(
                        '$streak${l10n.daysStreak}',
                        style: getLocalizedTextStyle(
                          context,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                    ],
                  ),
                  if (canUnlock)
                    Container(
                      margin: const EdgeInsets.only(top: 4),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        l10n.characterUnlockAvailable,
                        style: getLocalizedTextStyle(
                          context,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Progress Bar
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: canUnlock
                        ? [Colors.purple, Colors.pink]
                        : [Colors.blue, Colors.indigo],
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Motivational Text
          Text(
            _getMotivationalText(l10n),
            style: getLocalizedTextStyle(
              context,
              fontSize: 14,
              color: Colors.grey[600],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  String _getMotivationalText(AppLocalizations l10n) {
    if (canUnlock) {
      return l10n.allTasksCompleted;
    } else if (completed > 0) {
      return l10n.tasksRemaining(total - completed);
    } else {
      return l10n.startYourDay;
    }
  }
}
