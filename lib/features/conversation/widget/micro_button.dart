import 'package:flutter/material.dart';

class MicrophoneButton extends StatelessWidget {
  final Color iconColor;
  final Color backgroundColor;
  final VoidCallback onPressed;
  final bool isFlip;
  final double soundLevel;

  const MicrophoneButton({
    super.key,
    required this.iconColor,
    required this.backgroundColor,
    required this.onPressed,
    this.isFlip=false,
    required this.soundLevel,
  });

  @override
  Widget build(BuildContext context) {
    return
      Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: backgroundColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
                blurRadius: .26,
                spreadRadius: soundLevel * 1.5,
                color: Colors.black.withOpacity(.05))
          ],
        ),
        child: Center(
          child: Transform.flip(
            flipY: isFlip,
            child: IconButton(
              icon: const Icon(Icons.mic),
              color: iconColor,
              iconSize: 30,
              onPressed: onPressed,
            ),
          ),
        ),
      );

  }
}
