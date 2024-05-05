// ignore_for_file: must_be_immutable

import 'package:auto_route/annotations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/pages/main2/widget/main2_header.dart';
import 'package:myfit/presentation/pages/subscribtion_settings/widget/widget.dart';

@RoutePage()
class SubscribtionSettingsScreen extends StatefulWidget {
  const SubscribtionSettingsScreen({super.key});

  @override
  State<SubscribtionSettingsScreen> createState() => _SubscribtionSettingsScreenState();
}

class _SubscribtionSettingsScreenState extends State<SubscribtionSettingsScreen> {
  ScrollController? controller = ScrollController();
  GlobalKey howSubscribtionWorksBlockKey = GlobalKey();
  Offset position= Offset.zero;

  void getPostion() {
    final RenderBox renderBox = howSubscribtionWorksBlockKey.currentContext!.findRenderObject() as RenderBox;
    position = renderBox.localToGlobal(Offset.zero);
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPostion();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: const Main2Header(showBackButton: true, canNavigateToSettings: false),
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.only(left: 16.w, top: 16.h),
              child: CustomText(
                text: "Настройка вашей подписки",
                fontSize: 20.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          // Choose Subscribtion
          SliverToBoxAdapter(
            child: ChooseSubscribtion(
              onTap: (){
                controller?.animateTo(
                      position.dy - 60.h,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                    );
              },
            ),
          ),

          // Payment
          const SliverToBoxAdapter(
            child: PaymentSection(),
          ),

          // infos about Subscribtion
           SliverToBoxAdapter(
            child: InfosAboutSubscribtion(
              blockKey: howSubscribtionWorksBlockKey,
            ),
          ),
        ],
      ),
    );
  }
}
