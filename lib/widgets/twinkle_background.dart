import 'dart:math';
import 'package:flutter/material.dart';

class TwinkleBackground extends StatefulWidget {
  final Widget child;
  final int starCount;

  const TwinkleBackground({
    super.key,
    required this.child,
    this.starCount = 50,
  });

  @override
  State<TwinkleBackground> createState() => _TwinkleBackgroundState();
}

class _TwinkleBackgroundState extends State<TwinkleBackground>
    with TickerProviderStateMixin {
  late List<Star> stars;
  late List<AnimationController> controllers;

  @override
  void initState() {
    super.initState();
    _initializeStars();
  }

  void _initializeStars() {
    final random = Random();
    stars = List.generate(widget.starCount, (index) {
      return Star(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: random.nextDouble() * 3 + 1,
        color: _getRandomPastelColor(random),
      );
    });

    controllers = List.generate(widget.starCount, (index) {
      final controller = AnimationController(
        duration: Duration(milliseconds: 1000 + random.nextInt(2000)),
        vsync: this,
      );
      controller.repeat(reverse: true);
      return controller;
    });
  }

  Color _getRandomPastelColor(Random random) {
    final colors = [
      const Color(0xFFFFB4D6), // 파스텔 핑크
      const Color(0xFFB4A7FF), // 파스텔 퍼플
      const Color(0xFFA7D8FF), // 파스텔 블루
      const Color(0xFFFFE5A0), // 파스텔 옐로우
      const Color(0xFFFFD6E8), // 연한 핑크
      const Color(0xFFE8DFFF), // 연한 퍼플
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        IgnorePointer(
          child: CustomPaint(
            painter: TwinklePainter(
              stars: stars,
              animations: controllers.map((c) => c.view).toList(),
            ),
            size: Size.infinite,
          ),
        ),
      ],
    );
  }
}

class Star {
  final double x;
  final double y;
  final double size;
  final Color color;

  Star({
    required this.x,
    required this.y,
    required this.size,
    required this.color,
  });
}

class TwinklePainter extends CustomPainter {
  final List<Star> stars;
  final List<Animation<double>> animations;

  TwinklePainter({
    required this.stars,
    required this.animations,
  }) : super(repaint: Listenable.merge(animations));

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < stars.length; i++) {
      final star = stars[i];
      final animation = animations[i];
      final opacity = animation.value;

      final paint = Paint()
        ..color = star.color.withOpacity(opacity * 0.6)
        ..style = PaintingStyle.fill;

      final center = Offset(
        star.x * size.width,
        star.y * size.height,
      );

      // Draw star shape
      _drawStar(canvas, center, star.size, paint);

      // Draw glow effect
      final glowPaint = Paint()
        ..color = star.color.withOpacity(opacity * 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(center, star.size * 1.5, glowPaint);
    }
  }

  void _drawStar(Canvas canvas, Offset center, double size, Paint paint) {
    final path = Path();
    final outerRadius = size;
    final innerRadius = size * 0.4;
    final points = 5;

    for (int i = 0; i < points * 2; i++) {
      final angle = (i * pi / points) - pi / 2;
      final radius = i.isEven ? outerRadius : innerRadius;
      final x = center.dx + cos(angle) * radius;
      final y = center.dy + sin(angle) * radius;

      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(TwinklePainter oldDelegate) => false;
}
