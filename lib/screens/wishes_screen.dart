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
import '../widgets/animated_character.dart';
import '../l10n/app_localizations.dart';
import '../theme/lavender_theme.dart';

class WishesScreen extends StatefulWidget {
  const WishesScreen({super.key});

  @override
  State<WishesScreen> createState() => _WishesScreenState();
}

class _WishesScreenState extends State<WishesScreen>
    with TickerProviderStateMixin {
  late AnimationController _backgroundScrollController;

  @override
  void initState() {
    super.initState();
    _backgroundScrollController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _backgroundScrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: BlocConsumer<WishesBloc, WishesState>(
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
                    const Icon(Icons.error_outline,
                        size: 64, color: Color(0xFFEF4444)),
                    const SizedBox(height: 16),
                    Text('${l10n.errorOccurred}: ${state.message}'),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () =>
                          context.read<WishesBloc>().add(LoadTodayWishes()),
                      child: Text(l10n.tryAgain),
                    ),
                  ],
                ),
              );
            }

            if (state is WishesLoaded || state is WishFulfilled) {
              final wishes = state is WishesLoaded
                  ? state.wishes
                  : (state as WishFulfilled).wishes;

              return SingleChildScrollView(
                child: Column(
                  children: [
                    // Character background
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image:
                              AssetImage('assets/backgrounds/purple_bg.jpeg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      child: AnimatedBuilder(
                        animation: _backgroundScrollController,
                        builder: (context, child) {
                          final offset = _backgroundScrollController.value * 20;
                          final containerHeight =
                              MediaQuery.of(context).size.height * 0.5;
                          return Transform.translate(
                            offset: Offset(0, offset),
                            child: Stack(
                              children: [
                                // Character animation
                                SizedBox(
                                  width: double.infinity,
                                  height: containerHeight,
                                  child: AnimatedCharacter(
                                    containerSize: Size(
                                      MediaQuery.of(context).size.width,
                                      containerHeight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Wishes list
                    wishes.isEmpty
                        ? _buildEmptyState(context, l10n)
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: wishes.length - 1,
                            itemBuilder: (context, index) {
                              final wish = wishes[index + 1];
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
                                onDelete: () =>
                                    _showDeleteDialog(context, wish, l10n),
                                onEdit: () =>
                                    _showEditWishDialog(context, wish, l10n),
                              );
                            },
                          ),
                  ],
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
      floatingActionButton: GlassmorphicContainer(
        padding: const EdgeInsets.all(16),
        borderRadius: BorderRadius.circular(20),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddWishDialog(context, l10n),
          backgroundColor: Colors.transparent,
          elevation: 0,
          icon: Image.asset(
            'assets/tea.png',
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
          label: Text(l10n.newWish,
              style: const TextStyle(color: Color(0xFF7C3AED))),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, AppLocalizations l10n) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.star_outline,
            size: 80,
            color: Color(0xFFB794F6),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.noWishesToday,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: const Color(0xFF6B46C1),
                ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.tapToMakeWish,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF9CA3AF),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _showAddWishDialog(BuildContext context, AppLocalizations l10n) {
    _showWishDialog(context, null, l10n);
  }

  void _showEditWishDialog(
      BuildContext context, Wish wish, AppLocalizations l10n) {
    _showWishDialog(context, wish, l10n);
  }

  void _showWishDialog(
      BuildContext context, Wish? existingWish, AppLocalizations l10n) {
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
          title:
              Text(existingWish == null ? l10n.makeWishTitle : l10n.editWish),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: whatController,
                  decoration: InputDecoration(
                    labelText: l10n.whatWish,
                    hintText: l10n.whatHint,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whyController,
                  decoration: InputDecoration(
                    labelText: l10n.whyImportant,
                    hintText: l10n.whyHint,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whenController,
                  decoration: InputDecoration(
                    labelText: l10n.whenWant,
                    hintText: l10n.whenHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whereController,
                  decoration: InputDecoration(
                    labelText: l10n.whereHappen,
                    hintText: l10n.whereHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: whoController,
                  decoration: InputDecoration(
                    labelText: l10n.whoInvolved,
                    hintText: l10n.whoHint,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: howController,
                  decoration: InputDecoration(
                    labelText: l10n.howMakeHappen,
                    hintText: l10n.howHint,
                  ),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Text('${l10n.importance}: '),
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
                  decoration: InputDecoration(labelText: l10n.category),
                  items: [
                    DropdownMenuItem(
                        value: 'personal', child: Text(l10n.categoryPersonal)),
                    DropdownMenuItem(
                        value: 'career', child: Text(l10n.categoryCareer)),
                    DropdownMenuItem(
                        value: 'health', child: Text(l10n.categoryHealth)),
                    DropdownMenuItem(
                        value: 'relationships',
                        child: Text(l10n.categoryRelationships)),
                    DropdownMenuItem(
                        value: 'financial',
                        child: Text(l10n.categoryFinancial)),
                    DropdownMenuItem(
                        value: 'spiritual',
                        child: Text(l10n.categorySpiritual)),
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
              child: Text(l10n.cancel),
            ),
            ElevatedButton(
              onPressed: () {
                if (whatController.text.trim().isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.pleaseEnterWish)),
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
              child:
                  Text(existingWish == null ? l10n.makeWish : l10n.updateWish),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(
      BuildContext context, Wish wish, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text('Are you sure you want to delete "${wish.what}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          ElevatedButton(
            onPressed: () {
              context.read<WishesBloc>().add(DeleteWish(wishId: wish.id!));
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: Text(l10n.delete),
          ),
        ],
      ),
    );
  }
}
