import 'package:flutter/material.dart';

class Advertisement extends StatelessWidget {
  const Advertisement({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}

class BottomBanner extends StatelessWidget {
  const BottomBanner({
    super.key,
    required this.child,
    required this.placement,
  });

  final Widget child;
  final String placement;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Expanded(child: child),
    ]);
  }
}
