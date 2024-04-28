import 'package:myfit/presentation/components/bottom_navigation.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

@RoutePage()
class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CustomText(text: "Уведомлений пока у вас нет!"),
      ),
      bottomNavigationBar: const CustomBottomNavigation(),
    );
  }
}
