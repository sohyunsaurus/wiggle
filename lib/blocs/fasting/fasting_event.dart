// part of 'fasting_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:wiggle/models/fasting_record.dart';

abstract class FastingEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadTodayRecord extends FastingEvent {}

class SetFastingTime extends FastingEvent {
  final String date;
  final String startTime;
  final String endTime;

  SetFastingTime(
      {required this.date, required this.startTime, required this.endTime});

  @override
  List<Object?> get props => [date, startTime, endTime];
}

class CompleteFasting extends FastingEvent {
  final FastingRecord record;
  CompleteFasting({required this.record});

  @override
  List<Object?> get props => [record];
}
