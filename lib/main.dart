import 'package:activity/app_widget.dart';
import 'package:activity/infrastructure/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage.getSharedPreferences();

  runApp(
     ProviderScope(
      child: AppWidget(),
    ),
  );
}
