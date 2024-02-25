import 'package:activity/application/settings/settings_provider.dart';
import 'package:activity/infrastructure/services/apphelpers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

@RoutePage()
class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final event = ref.read(settingsProvider.notifier);
        return MobileScanner(
          onDetect: (capture) {
            if (capture.barcodes.isNotEmpty) {
              final Barcode barcode = capture.barcodes.first;
              event.setQrCodeValue(barcode.displayValue ?? "");
              context.router.pop();
            } else {
              AppHelpers.showErrorSnack(context, "QR код не найден");
              context.router.pop();
            }
          },
        );
      }),
    );
  }
}
