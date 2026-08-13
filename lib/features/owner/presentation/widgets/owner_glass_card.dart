import 'package:flutter/material.dart';

class OwnerGlassCard
    extends StatelessWidget {
  const OwnerGlassCard({
    super.key,
    required this.child,
  });

  final Widget child;

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      padding:
          const EdgeInsets.all(
        16,
      ),
      decoration:
          BoxDecoration(
        color:
            Colors.white.withValues(
          alpha: 0.045,
        ),
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border:
            Border.all(
          color:
              Colors.white.withValues(
            alpha: 0.07,
          ),
        ),
      ),
      child: child,
    );
  }
}
