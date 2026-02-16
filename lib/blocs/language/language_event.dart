// blocs/language/language_event.dart
import 'package:equatable/equatable.dart';

abstract class LanguageEvent extends Equatable {
  const LanguageEvent();

  @override
  List<Object?> get props => [];
}

class LoadLanguage extends LanguageEvent {}

class ChangeLanguage extends LanguageEvent {
  final String languageCode;

  const ChangeLanguage({required this.languageCode});

  @override
  List<Object?> get props => [languageCode];
}
