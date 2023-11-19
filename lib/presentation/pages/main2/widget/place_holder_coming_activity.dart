import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:flutter/material.dart';

class PlaceholderComingActivity extends StatelessWidget {
  const PlaceholderComingActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomCard(
      child: CustomText(
        text: "В ближайщее время у вас нет запланированных активностей",
      ),
    );
  }
}
