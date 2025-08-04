// lib/widgets/unhealthy_alert_card.dart

import 'package:flutter/material.dart';

class AlertCard extends StatefulWidget {
  final String title;
  final String subtitle;

  const AlertCard({
    super.key,
    this.title = "Unhealthy Air!",
    this.subtitle = "Open your windows!",
  });

  @override
  State<AlertCard> createState() => _AlertCardState();
}

class _AlertCardState extends State<AlertCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(); // loop forever
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // this gradient is 3 stops: dark → light → dark
              gradient: LinearGradient(
                colors: [
                  Colors.orange.shade700,
                  Colors.orange.shade400,
                  Colors.orange.shade700,
                ],
                stops: const [0, 0.5, 1],
                // repeat the pattern forever
                tileMode: TileMode.repeated,
                // slide it by a fraction of its own width
                transform: SlidingGradientTransform(slidePercent: _ctrl.value),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: child,
          );
        },
        // the content stays static
        child: Row(
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Colors.black,
              size: 60,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.subtitle,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tiny GradientTransform that just shifts the gradient horizontally
class SlidingGradientTransform extends GradientTransform {
  final double slidePercent;
  const SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    // move by a fraction of the width
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
