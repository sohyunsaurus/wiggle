// screens/home_screen.dart
import 'package:intl/intl.dart';
import '../models/fasting_record.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiggle/data/database_helper.dart';
import 'package:wiggle/blocs/fasting/fasting_bloc.dart';
import 'package:wiggle/blocs/fasting/fasting_event.dart';
import 'package:wiggle/blocs/fasting/fasting_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TimeOfDay? start;
  TimeOfDay? end;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('오늘의 단식')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: BlocBuilder<FastingBloc, FastingState>(
          builder: (context, state) {
            if (state is FastingLoaded || state is FastingCompleted) {
              final record = (state as dynamic).record;
              return _buildRecordView(record);
            } else if (state is FastingEmpty) {
              return _buildTimeSetter();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
    );
  }

  Widget _buildTimeSetter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('단식 시작 시간'),
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) setState(() => start = picked);
          },
          child: Text(start != null ? start!.format(context) : '시작 시간 선택'),
        ),
        const SizedBox(height: 20),
        Text('단식 종료 시간'),
        ElevatedButton(
          onPressed: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: TimeOfDay.now(),
            );
            if (picked != null) setState(() => end = picked);
          },
          child: Text(end != null ? end!.format(context) : '종료 시간 선택'),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () {
            if (start != null && end != null) {
              final now = DateTime.now();
              final today = DateFormat('yyyy-MM-dd').format(now);
              context.read<FastingBloc>().add(SetFastingTime(
                    date: today,
                    startTime: start!.format(context),
                    endTime: end!.format(context),
                  ));
            }
          },
          child: const Text('저장하기'),
        ),
      ],
    );
  }

  Widget _buildRecordView(FastingRecord record) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('오늘 설정된 단식 시간', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 16),
        Text('${record.startTime} ~ ${record.endTime}',
            style: Theme.of(context).textTheme.bodyLarge),
        const SizedBox(height: 24),
        record.success
            ? const Text('🎉 단식 성공! 캐릭터가 부화했어요!')
            : ElevatedButton(
                onPressed: () async {
                  final bloc = context.read<FastingBloc>();
                  final now = DateTime.now();
                  final today = DateFormat('yyyy-MM-dd').format(now);
                  final characterList = [
                    {'name': 'Chicko', 'asset': 'assets/characters/chick.png'},
                    {'name': 'Slimo', 'asset': 'assets/characters/slime.png'},
                  ];
                  final selected = (characterList..shuffle()).first;

                  final db = await DatabaseHelper.instance.database;
                  await db.insert('character_collection', {
                    'date': today,
                    'character_name': selected['name'],
                    'asset_path': selected['asset'],
                  });

                  bloc.add(CompleteFasting(record: record));
                },
                child: const Text('단식 완료로 표시하기'),
              ),
      ],
    );
  }
}
