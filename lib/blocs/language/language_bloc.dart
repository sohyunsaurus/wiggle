// blocs/language/language_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'language_event.dart';
import 'language_state.dart';

class LanguageBloc extends Bloc<LanguageEvent, LanguageState> {
  LanguageBloc() : super(LanguageInitial()) {
    on<LoadLanguage>(_onLoadLanguage);
    on<ChangeLanguage>(_onChangeLanguage);
  }

  Future<void> _onLoadLanguage(
      LoadLanguage event, Emitter<LanguageState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final languageCode = prefs.getString('language_code') ?? 'ko';
      emit(LanguageLoaded(locale: Locale(languageCode)));
    } catch (e) {
      // Default to Korean if error
      emit(const LanguageLoaded(locale: Locale('ko')));
    }
  }

  Future<void> _onChangeLanguage(
      ChangeLanguage event, Emitter<LanguageState> emit) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('language_code', event.languageCode);
      emit(LanguageLoaded(locale: Locale(event.languageCode)));
    } catch (e) {
      // Keep current state if error
      if (state is LanguageLoaded) {
        emit(state as LanguageLoaded);
      }
    }
  }
}
