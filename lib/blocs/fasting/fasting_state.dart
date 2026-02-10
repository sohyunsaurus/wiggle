// part of 'fasting_bloc.dart';

import 'package:equatable/equatable.dart';
import 'package:wiggle/models/fasting_record.dart';

abstract class FastingState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FastingInitial extends FastingState {}

class FastingEmpty extends FastingState {}

class FastingLoaded extends FastingState {
  final FastingRecord record;
  FastingLoaded(this.record);
  @override
  List<Object?> get props => [record];
}

class FastingCompleted extends FastingState {
  final FastingRecord record;
  FastingCompleted(this.record);
  @override
  List<Object?> get props => [record];
}
