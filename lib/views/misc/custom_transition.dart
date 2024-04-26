import 'package:flutter/material.dart';

class CustomTransition extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    const Offset slideToRight = Offset(1, 0);
    const Curve slideCurve = Curves.easeOutQuint;
    var forwardTransition = Tween<Offset>(
      begin: slideToRight,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: slideCurve,
      ),
    );
    var reverseTransition = Tween<Offset>(
      begin: slideToRight,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: animation,
        curve: Curves.easeInQuint,
      ),
    );
    return SlideTransition(
      position: animation.status == AnimationStatus.forward
          ? forwardTransition
          : reverseTransition,
      child: child,
    );
  }
}

class CustomRoute extends MaterialPageRoute {
  late Duration duration;
  Duration reverseduration = const Duration(milliseconds: 500);
  CustomRoute({
    required WidgetBuilder builder,
    bool maintainState = false,
    this.duration = const Duration(milliseconds: 500),
  }) : super(builder: builder, maintainState: maintainState);

  @override
  Duration get transitionDuration => duration;

  @override
  Duration get reverseTransitionDuration => reverseduration;
}
