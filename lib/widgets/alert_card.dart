// lib/widgets/unhealthy_alert_card.dart

import 'package:flutter/material.dart';

class AlertCard extends StatelessWidget {
  // We add these parameters so we can customize the text from the outside later.
  final String title;
  final String subtitle;

  const AlertCard({
    super.key,
    this.title = "Unhealthy Air!", // Default title
    this.subtitle = "Open your windows!", // Default subtitle
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      // The decoration creates the card's appearance (gradient, rounded corners).
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0),
        // This creates the orange gradient effect.
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade700,
            Colors.orange.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          // A subtle shadow to lift the card off the background.
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Part 1: The Icon on the left
          const Icon(
            Icons.warning_amber_rounded,
            color: Colors.black, // Using black as requested
            size: 40.0,
          ),
          const SizedBox(width: 16.0), // A little space between the icon and text

          // Part 2: The text block on the right
          // We use Expanded to ensure the text takes up the remaining space
          // and wraps correctly if it's too long.
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left
              children: [
                // The main headline
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0), // A little space between the two lines of text
                // The subtitle with the advice
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 16.0,
                    fontWeight: FontWeight.normal,
                  ),
                  // Allows the text to wrap onto multiple lines if needed.
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}