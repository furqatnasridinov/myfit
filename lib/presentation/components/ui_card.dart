import 'package:flutter/material.dart';

class UiCard extends StatelessWidget {
  final Widget cardValue;
  final double? cardMaxWidth;
  final double? cardHeight;

  const UiCard(
      {super.key, required this.cardValue, this.cardMaxWidth, this.cardHeight});

  @override
  Card build(BuildContext context) {
    return Card(
      elevation: 0.0,
      shape: RoundedRectangleBorder(
        side: const BorderSide(color: Color.fromRGBO(233, 233, 233, 1)),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Container(
        width: cardMaxWidth,
        height: cardHeight,
        padding: const EdgeInsets.all(16.0),
        child: cardValue,
      ),
    );
  }
}
