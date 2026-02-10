import 'data/database_helper.dart';
import 'theme/lavender_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:wiggle/screens/main_navigation_screen.dart';
import 'package:wiggle/blocs/wishes/wishes_bloc.dart';
import 'package:wiggle/blocs/wishes/wishes_event.dart';

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
      ],
      child: MaterialApp(
        title: 'Wiggle - Make a Wish ✨',
        theme: lightVioletTheme,
        home: const MainNavigationScreen(),
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', ''),
          Locale('ko', ''),
        ],
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
