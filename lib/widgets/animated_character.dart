import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

enum CharacterDirection {
  south,
  southEast,
  east,
  northEast,
  north,
  northWest,
  west,
  southWest,
}

class AnimatedCharacter extends StatefulWidget {
  final Size containerSize;

  const AnimatedCharacter({
    super.key,
    required this.containerSize,
  });

  @override
  State<AnimatedCharacter> createState() => _AnimatedCharacterState();
}

class _AnimatedCharacterState extends State<AnimatedCharacter>
    with TickerProviderStateMixin {
  late Offset currentPosition;
  late CharacterDirection currentDirection;
  late Timer movementTimer;
  late AnimationController positionController;
  final Random random = Random();
  final double characterSize = 80;
  final double speed = 2.0;

  @override
  void initState() {
    super.initState();
    // containerSize가 0이 아닌지 확인
    final width =
        widget.containerSize.width > 0 ? widget.containerSize.width : 300;
    final height =
        widget.containerSize.height > 0 ? widget.containerSize.height : 300;

    currentPosition = Offset(
      width / 2 - characterSize / 2,
      height / 2 - characterSize / 2,
    );
    currentDirection = CharacterDirection.south;
    positionController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _startMovement();
  }

  void _startMovement() {
    movementTimer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      if (mounted) {
        setState(() {
          _moveCharacter();
        });
      }
    });
  }

  void _moveCharacter() {
    // 랜덤하게 방향 선택 (가끔 멈추기)
    if (random.nextDouble() < 0.3) {
      // 30% 확률로 멈추기
      return;
    }

    final directions = CharacterDirection.values;
    currentDirection = directions[random.nextInt(directions.length)];

    Offset newPosition = currentPosition;

    switch (currentDirection) {
      case CharacterDirection.south:
        newPosition = Offset(currentPosition.dx, currentPosition.dy + speed);
        break;
      case CharacterDirection.southEast:
        newPosition = Offset(
          currentPosition.dx + speed * 0.7,
          currentPosition.dy + speed * 0.7,
        );
        break;
      case CharacterDirection.east:
        newPosition = Offset(currentPosition.dx + speed, currentPosition.dy);
        break;
      case CharacterDirection.northEast:
        newPosition = Offset(
          currentPosition.dx + speed * 0.7,
          currentPosition.dy - speed * 0.7,
        );
        break;
      case CharacterDirection.north:
        newPosition = Offset(currentPosition.dx, currentPosition.dy - speed);
        break;
      case CharacterDirection.northWest:
        newPosition = Offset(
          currentPosition.dx - speed * 0.7,
          currentPosition.dy - speed * 0.7,
        );
        break;
      case CharacterDirection.west:
        newPosition = Offset(currentPosition.dx - speed, currentPosition.dy);
        break;
      case CharacterDirection.southWest:
        newPosition = Offset(
          currentPosition.dx - speed * 0.7,
          currentPosition.dy + speed * 0.7,
        );
        break;
    }

    // 경계 체크
    final maxWidth =
        widget.containerSize.width > 0 ? widget.containerSize.width : 300;
    final maxHeight =
        widget.containerSize.height > 0 ? widget.containerSize.height : 300;

    newPosition = Offset(
      newPosition.dx.clamp(0, maxWidth - characterSize),
      newPosition.dy.clamp(0, maxHeight - characterSize),
    );

    currentPosition = newPosition;
  }

  String _getCharacterAsset() {
    switch (currentDirection) {
      case CharacterDirection.south:
        return 'assets/characters/jump_south.gif';
      case CharacterDirection.southEast:
        return 'assets/characters/jump_southeast.gif';
      case CharacterDirection.east:
        return 'assets/characters/jump_east.gif';
      case CharacterDirection.northEast:
        return 'assets/characters/jump_northeast.gif';
      case CharacterDirection.north:
        return 'assets/characters/jump_south.gif'; // Fallback to south
      case CharacterDirection.northWest:
        return 'assets/characters/jump_northwest.gif';
      case CharacterDirection.west:
        return 'assets/characters/jump_west.gif';
      case CharacterDirection.southWest:
        return 'assets/characters/jump_southwest.gif';
    }
  }

  String _getDirectionEmoji() {
    switch (currentDirection) {
      case CharacterDirection.south:
        return '⬇️';
      case CharacterDirection.southEast:
        return '↘️';
      case CharacterDirection.east:
        return '➡️';
      case CharacterDirection.northEast:
        return '↗️';
      case CharacterDirection.north:
        return '⬆️';
      case CharacterDirection.northWest:
        return '↖️';
      case CharacterDirection.west:
        return '⬅️';
      case CharacterDirection.southWest:
        return '↙️';
    }
  }

  @override
  void dispose() {
    movementTimer.cancel();
    positionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: currentPosition.dx,
          top: currentPosition.dy,
          child: SizedBox(
            width: characterSize,
            height: characterSize,
            child: _buildCharacterWidget(),
          ),
        ),
      ],
    );
  }

  Widget _buildCharacterWidget() {
    final assetPath = _getCharacterAsset();
    return Image.asset(
      assetPath,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to emoji if image fails to load
        return Container(
          decoration: BoxDecoration(
            color: Colors.purple.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: Colors.purpleAccent,
              width: 2,
            ),
          ),
          child: Center(
            child: Text(
              _getDirectionEmoji(),
              style: const TextStyle(fontSize: 32),
            ),
          ),
        );
      },
    );
  }
}
