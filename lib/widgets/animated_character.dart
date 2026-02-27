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
    currentPosition = Offset(
      widget.containerSize.width / 2,
      widget.containerSize.height / 2,
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
    newPosition = Offset(
      newPosition.dx.clamp(0, widget.containerSize.width - characterSize),
      newPosition.dy.clamp(0, widget.containerSize.height - characterSize),
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
        return 'assets/characters/jump_north.gif';
      case CharacterDirection.northWest:
        return 'assets/characters/jump_northwest.gif';
      case CharacterDirection.west:
        return 'assets/characters/jump_west.gif';
      case CharacterDirection.southWest:
        return 'assets/characters/jump_southwest.gif';
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
    return Positioned(
      left: currentPosition.dx,
      top: currentPosition.dy,
      child: SizedBox(
        width: characterSize,
        height: characterSize,
        child: Image.asset(
          _getCharacterAsset(),
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
