import 'package:flutter/material.dart';

class PageTransition {
  static PageRouteBuilder slideTransition(Widget page) {
    return PageRouteBuilder(
      transitionDuration: const Duration(microseconds: 1200),
      reverseTransitionDuration: const Duration(microseconds: 1200),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
