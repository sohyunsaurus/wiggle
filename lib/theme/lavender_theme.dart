// theme/lavender_theme.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:ui';

// Glassmorphism 라벤더/퍼플 테마
final ThemeData glassmorphismLavenderTheme = ThemeData(
  useMaterial3: true,
  brightness: Brightness.light,

  // 파스텔 톤 컬러 스킴
  colorScheme: const ColorScheme.light(
    primary: Color(0xFFFFB4D6), // 파스텔 핑크
    primaryContainer: Color(0xFFFFE5F1), // 연한 핑크
    secondary: Color(0xFFB4A7FF), // 파스텔 퍼플
    secondaryContainer: Color(0xFFE8DFFF), // 연한 퍼플
    tertiary: Color(0xFFA7D8FF), // 파스텔 블루
    surface: Color(0xFFFFFBFF), // 순백색 배경
    surfaceContainerHighest: Color(0xFFFFF5F8), // 매우 연한 핑크 표면
    onPrimary: Color(0xFF5D1049), // 진한 핑크
    onSecondary: Color(0xFF4C1D95), // 진한 퍼플
    onSurface: Color(0xFF1C1B1F),
    outline: Color(0xFFFFD6E8), // 연한 핑크 아웃라인
    shadow: Color(0x1AFFB4D6), // 핑크 그림자
  ),

  // 앱바 테마
  appBarTheme: AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: true,
    titleTextStyle: const TextStyle(
      color: Color(0xFF5D1049), // 진한 핑크
      fontSize: 20,
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5,
    ),
    iconTheme: const IconThemeData(
      color: Color(0xFFFF8FB4), // 파스텔 핑크
    ),
  ),

  // 카드 테마 (Glassmorphism)
  cardTheme: CardTheme(
    elevation: 0,
    color: Colors.transparent,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  ),

  // 플로팅 액션 버튼 테마
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Color(0xFFFFB4D6), // 파스텔 핑크
    foregroundColor: Colors.white,
    elevation: 8,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(16)),
    ),
  ),

  // 바텀 네비게이션 바 테마
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    backgroundColor: Colors.transparent,
    elevation: 0,
    selectedItemColor: Color(0xFFFF8FB4), // 파스텔 핑크
    unselectedItemColor: Color(0xFFB4A7FF), // 파스텔 퍼플
    type: BottomNavigationBarType.fixed,
  ),

  // 텍스트 테마 (Google Fonts 사용)
  textTheme: TextTheme(
    headlineLarge: GoogleFonts.hiMelody(
      color: const Color(0xFF5D1049), // 진한 핑크
      fontSize: 32,
      fontWeight: FontWeight.bold,
      letterSpacing: -0.5,
    ),
    headlineMedium: GoogleFonts.hiMelody(
      color: const Color(0xFF5D1049),
      fontSize: 28,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: GoogleFonts.hiMelody(
      color: const Color(0xFF5D1049),
      fontSize: 22,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: GoogleFonts.hiMelody(
      color: const Color(0xFFB4A7FF), // 파스텔 퍼플
      fontSize: 16,
      fontWeight: FontWeight.w500,
    ),
    bodyLarge: GoogleFonts.hiMelody(
      color: const Color(0xFF374151),
      fontSize: 16,
      fontWeight: FontWeight.normal,
    ),
    bodyMedium: GoogleFonts.hiMelody(
      color: const Color(0xFF6B7280),
      fontSize: 14,
      fontWeight: FontWeight.normal,
    ),
  ),

  // 입력 필드 테마
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: const Color(0x0FFFB4D6), // 매우 연한 핑크 배경
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFFFD6E8),
        width: 1,
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFFFE5F1),
        width: 1,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: Color(0xFFFFB4D6),
        width: 2,
      ),
    ),
    labelStyle: const TextStyle(
      color: Color(0xFF6B7280),
      fontSize: 14,
    ),
    hintStyle: const TextStyle(
      color: Color(0xFF9CA3AF),
      fontSize: 14,
    ),
  ),

  // 버튼 테마
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFFFB4D6), // 파스텔 핑크
      foregroundColor: Colors.white,
      elevation: 4,
      shadowColor: const Color(0x40FFB4D6),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      ),
    ),
  ),

  // 텍스트 버튼 테마
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: const Color(0xFFB4A7FF), // 파스텔 퍼플
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
  ),
);

// Glassmorphism 컨테이너 위젯
class GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final Color? color;
  final Border? border;

  const GlassmorphicContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 10.0,
    this.opacity = 0.1,
    this.color,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        border: border ??
            Border.all(
              color: Colors.white.withValues(alpha: 0.2),
              width: 1,
            ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFB4D6).withValues(alpha: 0.15),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  (color ?? const Color(0xFFFFFFFF))
                      .withValues(alpha: opacity + 0.1),
                  (color ?? const Color(0xFFF8FAFC)).withValues(alpha: opacity),
                ],
              ),
              borderRadius: borderRadius ?? BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

// 언어별 폰트 헬퍼 함수
TextStyle getLocalizedTextStyle(
  BuildContext context, {
  required double fontSize,
  FontWeight? fontWeight,
  Color? color,
}) {
  final locale = Localizations.localeOf(context);

  if (locale.languageCode == 'ko') {
    // 한국어용 하이 멜로디 폰트
    return GoogleFonts.hiMelody(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  } else {
    // 영어용 귀여운 폰트 (Comfortaa 사용)
    return GoogleFonts.comfortaa(
      fontSize: fontSize,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color,
    );
  }
}

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE5F1), // 파스텔 핑크
            Color(0xFFFFF0F5), // 연한 로즈
            Color(0xFFF3E8FF), // 파스텔 라벤더
            Color(0xFFE8F4FF), // 파스텔 블루
            Color(0xFFFFFBE6), // 파스텔 옐로우
          ],
          stops: [0.0, 0.25, 0.5, 0.75, 1.0],
        ),
      ),
      child: child,
    );
  }
}
