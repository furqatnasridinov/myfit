// ignore_for_file: must_be_immutable

import 'dart:math';

import 'package:auto_route/annotations.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_search_bar.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/pages/subscribtion_settings/widget/widget.dart';

@RoutePage()
class SubscribtionSettingsScreen extends ConsumerStatefulWidget {
  const SubscribtionSettingsScreen({super.key});

  @override
  ConsumerState<SubscribtionSettingsScreen> createState() =>
      _SubscribtionSettingsScreenState();
}

class _SubscribtionSettingsScreenState
    extends ConsumerState<SubscribtionSettingsScreen> {
  ScrollController? controller = ScrollController();
  late ConfettiController confettiController;
  GlobalKey howSubscribtionWorksBlockKey = GlobalKey();
  Offset position = Offset.zero;

  void getPostion() {
    final RenderBox renderBox = howSubscribtionWorksBlockKey.currentContext!.findRenderObject() as RenderBox;
    position = renderBox.localToGlobal(Offset.zero);
  }

  Future<void> animateToTop() async {
    controller?.animateTo(
      0,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  Future <void> playConfetti() async{
    confettiController.play();
    await Future.delayed(const Duration(milliseconds: 500));
    confettiController.stop();
  }


  @override
  void initState() {
    confettiController = ConfettiController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getPostion();
      ref.read(settingsProvider.notifier)
      ..getPromocodes(context)
      ..cleanLastPromocodeError();
    });
    super.initState();
  }

  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(settingsProvider, (previous, next) async{
      if (previous!.referalInfo?.receivedBonus != next.referalInfo?.receivedBonus && 
          (previous.referalInfo?.receivedBonus ?? 0) + 1 == next.referalInfo?.receivedBonus && next.takeBonusButtonClicked) {
        await animateToTop();
        playConfetti();
        ref.read(settingsProvider.notifier).setTakeButtonCliked(false);
      }
    },);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchBar(showBackButton: true, canNavigateToSettings: false),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          // screen
          CustomScrollView(
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
                  onTap: () {
                    controller?.animateTo(
                      position.dy - 60.h,
                      duration: const Duration(milliseconds: 700),
                      curve: Curves.easeInOut,
                    );
                  },
                ),
              ),
          
              // Promocode
              const SliverToBoxAdapter(
                child: PromocodeSection(),
              ),
          
              // Payment
              const SliverToBoxAdapter(
                child: PaymentSection(),
              ),
          
              // Invite Friends // referal
               const SliverToBoxAdapter(
                child: InviteFriendsSection(),
              ),
          
              // infos about Subscribtion
              SliverToBoxAdapter(
                child: InfosAboutSubscribtion(blockKey: howSubscribtionWorksBlockKey),
              ),
            ],
          ),

          // confetti
          Positioned(
            top: -70,
            child: ConfettiWidget(
              confettiController: confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 100,
              gravity: 0.8,
              displayTarget: true,
              blastDirection: pi / 2,
              emissionFrequency: 0.00,
              colors: const [
                AppColors.purpleText,
                AppColors.purpleBorder,
                AppColors.goldText,
                AppColors.goldBorder
              ],
            ),
          ),
        ],
      ),
    );
  }
}
