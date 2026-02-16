// screens/calendar_screen.dart
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';
import '../data/database_helper.dart';
import '../models/wish.dart';
import '../l10n/app_localizations.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late final ValueNotifier<List<Wish>> _selectedWishes;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  Map<DateTime, List<Wish>> _wishEvents = {};
  Map<DateTime, int> _wishCounts = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _selectedDay = DateTime.now();
    _selectedWishes = ValueNotifier(_getWishesForDay(_selectedDay!));
    _loadWishData();
  }

  @override
  void dispose() {
    _selectedWishes.dispose();
    super.dispose();
  }

  Future<void> _loadWishData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final db = await DatabaseHelper.instance.database;
      final result = await db.query('wishes', orderBy: 'date DESC');

      final wishes = result.map((map) => Wish.fromMap(map)).toList();

      // Group wishes by date
      final Map<DateTime, List<Wish>> events = {};
      final Map<DateTime, int> counts = {};

      for (final wish in wishes) {
        final date = DateTime.parse(wish.date);
        final dateKey = DateTime(date.year, date.month, date.day);

        if (events[dateKey] == null) {
          events[dateKey] = [];
        }
        events[dateKey]!.add(wish);
        counts[dateKey] = events[dateKey]!.length;
      }

      setState(() {
        _wishEvents = events;
        _wishCounts = counts;
        _isLoading = false;
      });

      // Update selected wishes
      _selectedWishes.value = _getWishesForDay(_selectedDay!);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text('${AppLocalizations.of(context)!.errorOccurred}: $e')),
        );
      }
    }
  }

  List<Wish> _getWishesForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _wishEvents[dateKey] ?? [];
  }

  int _getWishCountForDay(DateTime day) {
    final dateKey = DateTime(day.year, day.month, day.day);
    return _wishCounts[dateKey] ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.wishCalendar),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadWishData,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Calendar widget
                Container(
                  margin: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: TableCalendar<Wish>(
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    calendarFormat: _calendarFormat,
                    eventLoader: _getWishesForDay,
                    startingDayOfWeek: StartingDayOfWeek.monday,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      if (!isSameDay(_selectedDay, selectedDay)) {
                        setState(() {
                          _selectedDay = selectedDay;
                          _focusedDay = focusedDay;
                        });
                        _selectedWishes.value = _getWishesForDay(selectedDay);
                      }
                    },
                    onFormatChanged: (format) {
                      if (_calendarFormat != format) {
                        setState(() {
                          _calendarFormat = format;
                        });
                      }
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarStyle: CalendarStyle(
                      outsideDaysVisible: false,
                      weekendTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      holidayTextStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      selectedDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      todayDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        shape: BoxShape.circle,
                      ),
                      markerDecoration: const BoxDecoration(
                        color: Colors.amber,
                        shape: BoxShape.circle,
                      ),
                      markersMaxCount: 3,
                    ),
                    headerStyle: HeaderStyle(
                      formatButtonVisible: true,
                      titleCentered: true,
                      formatButtonShowsNext: false,
                      formatButtonDecoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      formatButtonTextStyle: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, day, wishes) {
                        final count = _getWishCountForDay(day);
                        if (count > 0) {
                          return Positioned(
                            right: 1,
                            bottom: 1,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.amber,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 16,
                                minHeight: 16,
                              ),
                              child: Text(
                                '$count',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          );
                        }
                        return null;
                      },
                    ),
                  ),
                ),

                // Monthly statistics
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context)
                            .colorScheme
                            .primary
                            .withValues(alpha: 0.1),
                        Theme.of(context)
                            .colorScheme
                            .secondary
                            .withValues(alpha: 0.1),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _buildMonthlyStats(l10n),
                ),

                const SizedBox(height: 16),

                // Selected day wishes
                Expanded(
                  child: ValueListenableBuilder<List<Wish>>(
                    valueListenable: _selectedWishes,
                    builder: (context, wishes, _) {
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _selectedDay != null
                                  ? '${DateFormat('M월 d일 (E)', 'ko_KR').format(_selectedDay!)} - ${wishes.length}개의 소원'
                                  : l10n.noWishesThisDay,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 12),
                            Expanded(
                              child: wishes.isEmpty
                                  ? Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.auto_awesome_outlined,
                                            size: 48,
                                            color: Colors.grey[400],
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            l10n.noWishesThisDay,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : ListView.builder(
                                      itemCount: wishes.length,
                                      itemBuilder: (context, index) {
                                        final wish = wishes[index];
                                        return _buildWishItem(wish);
                                      },
                                    ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildMonthlyStats(AppLocalizations l10n) {
    final currentMonth = DateTime(_focusedDay.year, _focusedDay.month);
    final monthWishes = _wishEvents.entries
        .where((entry) =>
            entry.key.year == currentMonth.year &&
            entry.key.month == currentMonth.month)
        .toList();

    final totalWishes =
        monthWishes.fold<int>(0, (sum, entry) => sum + entry.value.length);
    final fulfilledWishes = monthWishes.fold<int>(
        0, (sum, entry) => sum + entry.value.where((w) => w.fulfilled).length);
    final activeDays = monthWishes.length;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          l10n.totalWishes,
          '$totalWishes개',
          Icons.auto_awesome,
          Theme.of(context).colorScheme.primary,
        ),
        _buildStatItem(
          l10n.fulfilledWishes,
          '$fulfilledWishes개',
          Icons.star,
          Colors.amber,
        ),
        _buildStatItem(
          l10n.activeDays,
          '$activeDays일',
          Icons.calendar_today,
          Colors.green,
        ),
      ],
    );
  }

  Widget _buildStatItem(
      String label, String value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildWishItem(Wish wish) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            wish.fulfilled ? Colors.amber.withValues(alpha: 0.1) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: wish.fulfilled
              ? Colors.amber
              : Colors.grey.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            wish.fulfilled ? Icons.star : Icons.star_border,
            color: wish.fulfilled ? Colors.amber : Colors.grey,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  wish.what,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    decoration:
                        wish.fulfilled ? TextDecoration.lineThrough : null,
                    color: wish.fulfilled ? Colors.grey[600] : null,
                  ),
                ),
                if (wish.why.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    wish.why,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                      fontStyle: FontStyle.italic,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _getCategoryColor(wish.category).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              wish.category,
              style: TextStyle(
                fontSize: 10,
                color: _getCategoryColor(wish.category),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'personal':
        return Colors.purple;
      case 'career':
        return Colors.blue;
      case 'health':
        return Colors.green;
      case 'relationships':
        return Colors.pink;
      case 'financial':
        return Colors.orange;
      case 'spiritual':
        return Colors.indigo;
      default:
        return Colors.grey;
    }
  }
}
