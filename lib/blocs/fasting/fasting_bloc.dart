import 'package:sqflite/sqflite.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wiggle/blocs/fasting/fasting_event.dart';
import 'package:wiggle/blocs/fasting/fasting_state.dart';

import '../../data/database_helper.dart';
import '../../models/fasting_record.dart';

class FastingBloc extends Bloc<FastingEvent, FastingState> {
  FastingBloc() : super(FastingInitial()) {
    on<LoadTodayRecord>(_onLoadTodayRecord);
    on<SetFastingTime>(_onSetFastingTime);
    on<CompleteFasting>(_onCompleteFasting);
  }

  Future<void> _onLoadTodayRecord(
    LoadTodayRecord event,
    Emitter<FastingState> emit,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final today = DateTime.now().toIso8601String().substring(0, 10);
    final result = await db.query(
      'fasting_records',
      where: 'date = ?',
      whereArgs: [today],
    );

    if (result.isEmpty) {
      emit(FastingEmpty());
    } else {
      final record = FastingRecord.fromMap(result.first);
      emit(FastingLoaded(record));
    }
  }

  Future<void> _onSetFastingTime(
    SetFastingTime event,
    Emitter<FastingState> emit,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final record = FastingRecord(
      date: event.date,
      startTime: event.startTime,
      endTime: event.endTime,
      success: false,
    );
    await db.insert('fasting_records', record.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
    emit(FastingLoaded(record));
  }

  Future<void> _onCompleteFasting(
    CompleteFasting event,
    Emitter<FastingState> emit,
  ) async {
    final db = await DatabaseHelper.instance.database;
    final record = event.record.copyWith(success: true);
    await db.update(
      'fasting_records',
      record.toMap(),
      where: 'date = ?',
      whereArgs: [record.date],
    );
    emit(FastingCompleted(record));
  }
}
