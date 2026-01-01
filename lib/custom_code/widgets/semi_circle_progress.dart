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

class SemiCircleProgress extends StatefulWidget {
  const SemiCircleProgress({
    Key? key,
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.text,
    this.width = 200.0,
    this.height = 100.0,
    this.textColor = Colors.black,
    this.fontSize = 14.0,
    this.thickness = 10.0,
    this.showText = true,
    this.gradeOfCircle = 180.0,
    this.animationDuration = 200,
  }) : super(key: key);

  final double width;
  final double height;
  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final String text;
  final Color textColor;
  final double fontSize;
  final double thickness;
  final bool showText;
  final double gradeOfCircle;
  final int animationDuration;

  @override
  State<SemiCircleProgress> createState() => _SemiCircleProgressState();
}

class _SemiCircleProgressState extends State<SemiCircleProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  double _previousProgress = 0;

  @override
  void initState() {
    super.initState();
    _previousProgress = widget.progress;
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.animationDuration),
    );

    _progressAnimation = Tween<double>(
      begin: 0,
      end: widget.progress,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
  }

  @override
  void didUpdateWidget(SemiCircleProgress oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.progress != widget.progress) {
      _previousProgress = _progressAnimation.value;
      _animationController.reset();

      _progressAnimation = Tween<double>(
        begin: _previousProgress,
        end: widget.progress,
      ).animate(
        CurvedAnimation(
          parent: _animationController,
          curve: Curves.easeInOut,
        ),
      );

      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clampedGrade = widget.gradeOfCircle.clamp(180.0, 270.0);
    final gradeInRadians = clampedGrade * (math.pi / 180);

    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return CustomPaint(
            painter: _SemiCirclePainter(
              progress: _progressAnimation.value,
              progressColor: widget.progressColor,
              backgroundColor: widget.backgroundColor,
              thickness: widget.thickness,
              gradeInRadians: gradeInRadians,
              totalGrade: clampedGrade,
            ),
            child: widget.showText
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.text,
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.fontSize,
                          ),
                        ),
                        Text(
                          '${(_progressAnimation.value * 100).toStringAsFixed(0)}%',
                          style: TextStyle(
                            color: widget.textColor,
                            fontSize: widget.fontSize,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
          );
        },
      ),
    );
  }
}

class _SemiCirclePainter extends CustomPainter {
  _SemiCirclePainter({
    required this.progress,
    required this.progressColor,
    required this.backgroundColor,
    required this.thickness,
    required this.gradeInRadians,
    required this.totalGrade,
  });

  final double progress;
  final Color progressColor;
  final Color backgroundColor;
  final double thickness;
  final double gradeInRadians;
  final double totalGrade;

  @override
  void paint(Canvas canvas, Size size) {
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height + (size.height * 0.2));
    final radius = size.width / 2;
    final startAngle = math.pi + (math.pi - gradeInRadians) / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      gradeInRadians,
      false,
      backgroundPaint,
    );

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      gradeInRadians * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Set your widget name, define your parameter, and then add the
// boilerplate code using the green button on the right!
