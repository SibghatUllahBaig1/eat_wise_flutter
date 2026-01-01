// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'index.dart'; // Imports other custom widgets
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom widget code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:math' as math;

class WaterCircleProgressBar extends StatefulWidget {
  const WaterCircleProgressBar({
    Key? key,
    required this.width,
    required this.height,
    this.progress = 0.5,
    this.waveAmplitude = 10,
    this.waveFrequency = 1.5,
    this.borderWidth = 8,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.borderColor = const Color(0xFF2196F3),
    this.waterColor = const Color(0xFF64B5F6),
    this.textColor = Colors.white,
    this.textSize = 24.0,
    this.showPercentage = true,
  }) : super(key: key);

  final double width;
  final double height;
  final double progress;
  final double waveAmplitude;
  final double waveFrequency;
  final double borderWidth;
  final Color backgroundColor;
  final Color borderColor;
  final Color waterColor;
  final Color textColor;
  final double textSize;
  final bool showPercentage;

  @override
  _WaterCircleProgressBarState createState() => _WaterCircleProgressBarState();
}

class _WaterCircleProgressBarState extends State<WaterCircleProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Use the smallest dimension to maintain circle shape
    final diameter = math.min(widget.width, widget.height);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Center(
        child: SizedBox(
          width: diameter,
          height: diameter,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return CustomPaint(
                painter: _WaterCirclePainter(
                  progress: widget.progress,
                  waveAmplitude: widget.waveAmplitude,
                  waveFrequency: widget.waveFrequency,
                  borderWidth: widget.borderWidth,
                  backgroundColor: widget.backgroundColor,
                  borderColor: widget.borderColor,
                  waterColor: widget.waterColor,
                  animationValue: _animationController.value,
                  diameter: diameter,
                ),
                child: widget.showPercentage
                    ? Center(
                        child: Text(
                          '${(widget.progress * 100).round()}%',
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.textSize,
                          ),
                        ),
                      )
                    : null,
              );
            },
          ),
        ),
      ),
    );
  }
}

class _WaterCirclePainter extends CustomPainter {
  _WaterCirclePainter({
    required this.progress,
    required this.waveAmplitude,
    required this.waveFrequency,
    required this.borderWidth,
    required this.backgroundColor,
    required this.borderColor,
    required this.waterColor,
    required this.animationValue,
    required this.diameter,
  });

  final double progress;
  final double waveAmplitude;
  final double waveFrequency;
  final double borderWidth;
  final Color backgroundColor;
  final Color borderColor;
  final Color waterColor;
  final double animationValue;
  final double diameter;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = diameter / 2 - borderWidth / 2;

    // Draw background circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius, backgroundPaint);

    // Draw border
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;
    canvas.drawCircle(center, radius, borderPaint);

    // Draw water
    final waterPaint = Paint()..color = waterColor;
    final path = Path();

    final waterLevel = (1 - progress) * diameter;

    path.moveTo(0, waterLevel);

    for (double i = 0; i <= diameter; i++) {
      final y = waterLevel +
          waveAmplitude *
              math.sin((i / diameter * 2 * math.pi * waveFrequency) +
                  animationValue * 2 * math.pi);
      path.lineTo(i, y);
    }

    path.lineTo(diameter, diameter);
    path.lineTo(0, diameter);
    path.close();

    // Clip to circle
    final clipPath = Path()
      ..addOval(Rect.fromCircle(center: center, radius: radius));
    canvas.clipPath(clipPath);
    canvas.drawPath(path, waterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
