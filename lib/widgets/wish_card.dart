// widgets/wish_card.dart
import 'package:flutter/material.dart';
import '../models/wish.dart';

class WishCard extends StatelessWidget {
  final Wish wish;
  final Function(bool) onToggle;
  final VoidCallback onDelete;
  final VoidCallback? onEdit;

  const WishCard({
    super.key,
    required this.wish,
    required this.onToggle,
    required this.onDelete,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: wish.fulfilled ? 8 : 4,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: wish.fulfilled
              ? LinearGradient(
                  colors: [
                    const Color(0xFFB4A7FF).withOpacity(0.3),
                    const Color(0xFFE8DFFF).withOpacity(0.2),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                )
              : null,
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => onToggle(!wish.fulfilled),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: wish.fulfilled
                              ? const Color(0xFFB4A7FF)
                              : Theme.of(context).colorScheme.primary,
                          width: 2,
                        ),
                        color: wish.fulfilled
                            ? const Color(0xFFB4A7FF)
                            : Colors.transparent,
                      ),
                      child: wish.fulfilled
                          ? const Icon(
                              Icons.star,
                              color: Colors.white,
                              size: 16,
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      wish.what,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            decoration: wish.fulfilled
                                ? TextDecoration.lineThrough
                                : null,
                            color: wish.fulfilled
                                ? Colors.grey[600]
                                : Theme.of(context).colorScheme.onSurface,
                            fontWeight: wish.importance > 3
                                ? FontWeight.bold
                                : FontWeight.w600,
                          ),
                    ),
                  ),
                  _buildImportanceIndicator(),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit' && onEdit != null) {
                        onEdit!();
                      } else if (value == 'delete') {
                        onDelete();
                      }
                    },
                    itemBuilder: (context) => [
                      if (onEdit != null)
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18),
                              SizedBox(width: 8),
                              Text('Edit'),
                            ],
                          ),
                        ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 18, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Delete', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (wish.why.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  'Why: ${wish.why}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: wish.fulfilled
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontStyle: FontStyle.italic,
                      ),
                ),
              ],
              const SizedBox(height: 12),
              _buildWishDetails(),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildCategoryChip(),
                  const Spacer(),
                  if (wish.fulfilled)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFB4A7FF).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFB4A7FF)),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.star, color: Color(0xFFB4A7FF), size: 16),
                          SizedBox(width: 4),
                          Text(
                            'Fulfilled ✨',
                            style: TextStyle(
                              color: Color(0xFFB4A7FF),
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImportanceIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        return Icon(
          index < wish.importance ? Icons.star : Icons.star_border,
          color: Colors.amber,
          size: 16,
        );
      }),
    );
  }

  Widget _buildWishDetails() {
    return Column(
      children: [
        if (wish.when.isNotEmpty)
          _buildDetailRow('When', wish.when, Icons.schedule),
        if (wish.where.isNotEmpty)
          _buildDetailRow('Where', wish.where, Icons.place),
        if (wish.who.isNotEmpty) _buildDetailRow('Who', wish.who, Icons.people),
        if (wish.how.isNotEmpty)
          _buildDetailRow('How', wish.how, Icons.lightbulb),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip() {
    final categoryColors = {
      'personal': Colors.purple,
      'career': Colors.blue,
      'health': Colors.green,
      'relationships': Colors.pink,
      'financial': Colors.orange,
      'spiritual': Colors.indigo,
    };

    final color = categoryColors[wish.category] ?? Colors.grey;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        wish.category.toUpperCase(),
        style: TextStyle(
          color: color,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
