import 'data/database_helper.dart';
import 'theme/lavender_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wiggle/screens/main_navigation_screen.dart';
import 'package:wiggle/blocs/wishes/wishes_bloc.dart';
import 'package:wiggle/blocs/wishes/wishes_event.dart';
import 'package:wiggle/blocs/language/language_bloc.dart';
import 'package:wiggle/blocs/language/language_event.dart';
import 'package:wiggle/blocs/language/language_state.dart';
import 'package:wiggle/l10n/app_localizations.dart';
import 'package:wiggle/widgets/twinkle_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DatabaseHelper.instance.initDB();

  // Uncomment the line below if you need to reset the database during development
  // await DatabaseHelper.instance.resetDatabase();

  runApp(const WiggleApp());
}

class WiggleApp extends StatelessWidget {
  const WiggleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => WishesBloc()..add(LoadTodayWishes())),
        BlocProvider(create: (_) => LanguageBloc()..add(LoadLanguage())),
      ],
      child: BlocBuilder<LanguageBloc, LanguageState>(
        builder: (context, languageState) {
          Locale locale = const Locale('ko'); // Default to Korean
          if (languageState is LanguageLoaded) {
            locale = languageState.locale;
          }

          return MaterialApp(
            title: 'Wiggle - Make a Wish ✨',
            theme: glassmorphismLavenderTheme,
            home: TwinkleBackground(
              starCount: 60,
              child: GradientBackground(
                child: const MainNavigationScreen(),
              ),
            ),
            locale: locale,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('ko'),
              Locale('en'),
            ],
            debugShowCheckedModeBanner: false,
          );
        },
      ),
    );
  }
}
