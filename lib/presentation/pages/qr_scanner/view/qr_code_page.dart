// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:activity/application/main2/main2_provider.dart';
import 'package:activity/application/schedule/schedule_provider.dart';
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
        final event = ref.read(scheduleProvider.notifier);
        final nearestLesson = ref.watch(main2Provider).nearestLesson;
        return MobileScanner(
          onDetect: (capture) async {
            if (capture.barcodes.isNotEmpty)  {
              final Barcode barcode = capture.barcodes.first;
              try {
                // barcode == https://myfit.com/aWQ9MTNuYW1lPUFiZHVsbG8gYWtv
              // handle qrcode value
              final List<String> parts = barcode.displayValue.toString().split("myfit.com/");
              String b64Decoded = parts[1];
              Codec<String, String> stringToBase64 = utf8.fuse(base64);
              String decoded = stringToBase64.decode(b64Decoded); //id=13name=Abdullo ako
              final List<String> parts2 = decoded.split("name=");
              final String gymId = parts2[0].split("=")[1];
              if (nearestLesson?.bodyData?.gym?.id == int.parse(gymId)) {
                // success case
               await event.makeLessonInProgress(
                  context,
                  gymId: nearestLesson?.bodyData?.gym?.id ?? 0,
                  lessonId: nearestLesson?.bodyData?.id ?? 0,
                );
              ref.read(main2Provider.notifier)
              ..hideBottomScanContainer()
              ..removeNearestLesson();
              //await ref.read(main2Provider.notifier).getNearestLesson(context);
              context.router.pop();
              AppHelpers.showSuccessSnack(context, "QR code validated successfully.");
              }else{
                AppHelpers.showErrorSnack(context, "QR code not validated. Please scan the correct QR code.");
                context.router.pop();
              }
              } catch (e) {
               AppHelpers.showErrorSnack(context, e.toString());
               context.router.pop();
              }
              //context.router.pop();
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
