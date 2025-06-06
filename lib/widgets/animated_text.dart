import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class FancyAnimatedText extends StatelessWidget {
  const FancyAnimatedText({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedTextKit(
      isRepeatingAnimation: true, 
      repeatForever: true, 
      pause: Duration(seconds: 2),
      animatedTexts: [
        TypewriterAnimatedText(
          'Growth and Development.',
          textStyle: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue.shade700,
          ),
          speed: const Duration(milliseconds: 150),
          cursor: '',
        ),
      ],
    );
  }
}
