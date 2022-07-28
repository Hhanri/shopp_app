import 'package:flutter/material.dart';

class BadgeWidget extends StatelessWidget {
  final Widget child;
  final String value;
  const BadgeWidget({Key? key, required this.child, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
          top: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.secondary
            ),
            constraints: const BoxConstraints(
              maxWidth: 16,
              maxHeight: 16
            ),
            child: Text(
              value,
              textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 10
                ),
            ),
          ),
        )
      ],
    );
  }
}
