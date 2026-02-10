// screens/wishes_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../blocs/wishes/wishes_bloc.dart';
import '../blocs/wishes/wishes_event.dart';
import '../blocs/wishes/wishes_state.dart';
import '../models/wish.dart';
import '../widgets/character_unlock_dialog.dart';
import '../widgets/wish_card.dart';
import '../widgets/progress_indicator_widget.dart';

class WishesScreen extends StatelessWidget {
  const WishesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Make a Wish ✨ ${DateFormat('M/d').format(DateTime.now())}'),
      ),
      body: BlocConsumer<WishesBloc, WishesState>(
        listener: (context, state) {
          if (state is WishFulfilled && state.unlockedCharacter != null) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) =>
                  CharacterUnlockDialog(character: state.unlockedCharacter!),
            );
          }
        },
        builder: (context, state) {
          if (state is WishesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WishesError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('오류가 발생했습니다: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<WishesBloc>().add(LoadTodayWishes()),
                    child: const Text('다시 시도'),
                  ),
                ],
              ),
            );
          }

          if (state is WishesLoaded || state is WishFulfilled) {
            final wishes = state is WishesLoaded
                ? state.wishes
                : (state as WishFulfilled).wishes;
            final fulfilledCount = state is WishesLoaded
                ? state.fulfilledCount
                : (state as WishFulfilled).fulfilledCount;
            final totalCount = state is WishesLoaded
                ? state.totalCount
                : (state as WishFulfilled).totalCount;
            final streak = state is WishesLoaded
                ? state.currentStreak
                : (state as WishFulfilled).currentStreak;
            final canUnlock = state is WishesLoaded
                ? state.canUnlockCharacter
                : (state as WishFulfilled).allWishesFulfilled;

            return Column(
              children: [
                // Progress header
                Container(
                  margin: const EdgeInsets.all(16),
                  child: ProgressIndicatorWidget(
                    completed: fulfilledCount,
                    total: totalCount,
                    streak: streak,
                    canUnlock: canUnlock,
                  ),
                ),

                // Wishes list
                Expanded(
                  child: wishes.isEmpty
                      ? _buildEmptyState(context)
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: wishes.length,
                          itemBuilder: (context, index) {
                            final wish = wishes[index];
                            return WishCard(
                              wish: wish,
                              onToggle: (fulfilled) {
                                if (fulfilled) {
                                  context
                                      .read<WishesBloc>()
                                      .add(FulfillWish(wishId: wish.id!));
                                } else {
                                  context
                                      .read<WishesBloc>()
                                      .add(UnfulfillWish(wishId: wish.id!));
                                }
                              },
                              onDelete: () => _showDeleteDialog(context, wish),
                              onEdit: () => _showEditWishDialog(context, wish),
                            );
                          },
                        ),
                ),
              ],
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddWishDialog(context),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('New Wish'),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.auto_awesome_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No wishes yet today',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the button below to make your first wish! ✨',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddWishDialog(BuildContext context) {
    _showWishDialog(context, null);
  }

  void _showEditWishDialog(BuildContext context, Wish wish) {
    _showWishDialog(context, wish);
  }

  void _showWishDialog(BuildContext context, Wish? existingWish) {
    final whatController =
        TextEditingController(text: existingWish?.what ?? '');
    final whyController = TextEditingController(text: existingWish?.why ?? '');
    final whenController =
        TextEditingController(text: existingWish?.when ?? '');
    final whereController =
        TextEditingController(text: existingWish?.where ?? '');
    final whoController = TextEditingController(text: existingWish?.who ?? '');
    final howController = TextEditingController(text: existingWish?.how ?? '');

    int importance = existingWish?.importance ?? 3;
    String category = existingWish?.category ?? 'personal';

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(existingWish == null ? 'Make a Wish ✨' : 'Edit Wish ✨'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: whatController,
                  decoration: const InputDecoration(
                    labelText: 'What do you wish for? *',
                    hintText: 'I wish to...',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whyController,
                  decoration: const InputDecoration(
                    labelText: 'Why is this important?',
                    hintText: 'Because...',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whenController,
                  decoration: const InputDecoration(
                    labelText: 'When do you want this?',
                    hintText: 'By next month...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whereController,
                  decoration: const InputDecoration(
                    labelText: 'Where will this happen?',
                    hintText: 'At home, work...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whoController,
                  decoration: const InputDecoration(
                    labelText: 'Who is involved?',
                    hintText: 'Me, my family...',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: howController,
                  decoration: const InputDecoration(
                    labelText: 'How will you make it happen?',
                    hintText: 'By working hard...',
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Importance: '),
                    Expanded(
                      child: Slider(
                        value: importance.toDouble(),
                        min: 1,
                        max: 5,
                        divisions: 4,
                        label: importance.toString(),
                        onChanged: (value) {
                          setState(() {
                            importance = value.round();
                          });
                        },
                      ),
                    ),
                  ],
                ),
                DropdownButtonFormField<String>(
                  value: category,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: const [
                    DropdownMenuItem(
                        value: 'personal', child: Text('Personal')),
                    DropdownMenuItem(value: 'career', child: Text('Career')),
                    DropdownMenuItem(value: 'health', child: Text('Health')),
                    DropdownMenuItem(
                        value: 'relationships', child: Text('Relationships')),
                    DropdownMenuItem(
                        value: 'financial', child: Text('Financial')),
                    DropdownMenuItem(
                        value: 'spiritual', child: Text('Spiritual')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      category = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                if (whatController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please enter what you wish for')),
                  );
                  return;
                }

                final wish = Wish(
                  id: existingWish?.id,
                  date: existingWish?.date ??
                      DateFormat('yyyy-MM-dd').format(DateTime.now()),
                  what: whatController.text.trim(),
                  why: whyController.text.trim(),
                  when: whenController.text.trim(),
                  where: whereController.text.trim(),
                  who: whoController.text.trim(),
                  how: howController.text.trim(),
                  importance: importance,
                  category: category,
                  fulfilled: existingWish?.fulfilled ?? false,
                );

                if (existingWish == null) {
                  context.read<WishesBloc>().add(AddWish(wish: wish));
                } else {
                  context.read<WishesBloc>().add(UpdateWish(wish: wish));
                }

                Navigator.pop(context);
              },
              child: Text(existingWish == null ? 'Make Wish' : 'Update Wish'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Wish wish) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Wish'),
        content: Text('Are you sure you want to delete "${wish.what}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WishesBloc>().add(DeleteWish(wishId: wish.id!));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
