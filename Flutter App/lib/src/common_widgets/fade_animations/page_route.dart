import 'package:flutter/material.dart';

import 'fade_out_animations.dart';

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  final Duration duration;

  FadeRoute({required this.page, this.duration = const Duration(seconds: 1)})
      : super(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionDuration: duration,
    reverseTransitionDuration: duration,
    transitionsBuilder:
        (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    if (animation.status == AnimationStatus.reverse) {
      return FadeOutAnimation(
        duration: duration,
        onAnimationEnd: () {
          Navigator.of(context).pop();
        },
        child: child,
      );
    }
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}
