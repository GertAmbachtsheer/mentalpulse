import 'package:flutter/material.dart';

class CrisisBanner extends StatelessWidget {
  const CrisisBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: const Color(0xFFEF4444), // Red color
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: const Text(
        'Crisis? Call 0781740616 or WhatsApp 24/7 free confidential support',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w500,
          fontSize: 14,
        ),
      ),
    );
  }
}
