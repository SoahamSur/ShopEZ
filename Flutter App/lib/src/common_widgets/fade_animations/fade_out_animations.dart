import 'package:flutter/material.dart';

class FadeOutAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback onAnimationEnd;

  const FadeOutAnimation({
    Key? key,
    required this.child,
    this.duration = const Duration(seconds: 1),
    required this.onAnimationEnd,
  }) : super(key: key);

  @override
  _FadeOutAnimationState createState() => _FadeOutAnimationState();
}

class _FadeOutAnimationState extends State<FadeOutAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.reverse(from: 1.0).then((value) {
      widget.onAnimationEnd();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black, // Set the background color to black
      child: FadeTransition(
        opacity: _animation,
        child: widget.child,
      ),
    );
  }
}
