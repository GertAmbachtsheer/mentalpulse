import 'package:flutter/material.dart';

/// A widget that adds padding based on the keyboard's height (viewInsets.bottom).
/// By using [MediaQuery.viewInsetsOf], we ensure that only this widget rebuilds
/// when the keyboard toggles, rather than the entire page.
class KeyboardPadding extends StatelessWidget {
  final Widget child;

  const KeyboardPadding({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    // Only listen to viewInsets changes, which is more efficient for keyboard toggling.
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: child,
    );
  }
}
