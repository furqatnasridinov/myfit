// ignore_for_file: use_build_context_synchronously
import 'dart:convert';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/main2/main2_provider.dart';
import 'package:myfit/application/schedule/schedule_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:myfit/presentation/components/custom_button.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:permission_handler/permission_handler.dart';

@RoutePage()
class QrCodeScreen extends StatelessWidget {
  const QrCodeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        title: CustomText(
          text: "Сканирование QR кода",
          fontSize: 16.sp,
          fontWeight: FontWeight.w400,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.router.stack.length > 1) {
              context.router.pop();
            } else {
              context.router.replaceAll([const Main2Route()]);
            }
          },
        )
      ),
      body: Consumer(builder: (context, ref, child) {
        final event = ref.read(scheduleProvider.notifier);
        final nearestLesson = ref.watch(main2Provider).nearestLesson;
        return MobileScanner(
          onDetect: (capture) async {
            if (capture.barcodes.isNotEmpty) {
              final Barcode barcode = capture.barcodes.first;
              try {
                // barcode == https://myfit.com/aWQ9MTNuYW1lPUFiZHVsbG8gYWtv
                // handle qrcode value
                final List<String> parts =
                    barcode.displayValue.toString().split("myfit.com/");
                String b64Decoded = parts[1];
                Codec<String, String> stringToBase64 = utf8.fuse(base64);
                String decoded =
                    stringToBase64.decode(b64Decoded); //id=13name=Abdullo ako
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
                  AppHelpers.showSuccessSnack(
                      context, "QR code успешно отсканирован!");
                } else {
                  AppHelpers.showErrorSnack(context,
                      "QR code не соответствует текущему занятию!");
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
          errorBuilder: (context, error, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CustomText(
                  text: "Доступ к камере не предоставлен!",
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
                15.verticalSpace,
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.w),
                  child: CustomButton(
                    height: 40.h,
                    onPressed: () async {
                      var status = await Permission.camera.status;
                      if (status.isDenied) {
                        // We didn't ask for permission yet or the permission has been denied before but not permanently.
                        status = await Permission.camera.request();

                        if (status.isGranted) {
                          // We got the permission to use the camera.
                        } else if (status.isPermanentlyDenied || status.isDenied) {
                          // The permission has been permanently denied, we cannot request it anymore.
                          openAppSettings();
                        }
                      } 
                    },
                    text: " Включить доступ к камере",
                  ),
                ),
              ],
            );
          },
        );
      }),
    );
  }
}
