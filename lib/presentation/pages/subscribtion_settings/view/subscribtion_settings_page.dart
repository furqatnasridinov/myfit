// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:math';
import 'package:auto_route/auto_route.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myfit/application/settings/settings_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/presentation/components/custom_button.dart';
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
      //..getPromocodes(context)
      ..getPromocodesQueue(context)
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

      // делаем такую логику потому что при переходе по динамической ссылке сразу же previous.isFromReferalDeepLink будет тру
      if (previous.isFromReferalDeepLink == next.isFromReferalDeepLink && previous.isFromReferalDeepLink) {
        final notifier = ref.read(settingsProvider.notifier);
        notifier.setIsFromReferalDeepLink(false);
        await notifier.applyPromocede(context, code: next.referalDeepLinkValue, autoRefresh: false);
        showDialog(
            context: context,
            builder: (context) {
              return Dialog(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 0,
                insetPadding: EdgeInsets.symmetric(horizontal: 16.w),
                child: refDialogInfo(),
              );
            },
          );
        await notifier.getUserSubscribtions(context);
        await notifier.getReferalInfo(context);
        notifier.getAllAvailableSubscribtions(context);
      }
    },);
    
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: CustomSearchBar(showBackButton: true, canNavigateToSettings: true),
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

Widget refDialogInfo(){
  return Padding(
    padding: EdgeInsets.all(16.r),
    child: Consumer(
      builder: (context, ref, child) {
        final bool  isPromocodeSuccess = ref.watch(settingsProvider).isPromocodeSuccess;
        final String newPromocodeDescription = ref.watch(settingsProvider).newPromocodeDescription;
        final bool isPromocodeError = ref.watch(settingsProvider).isPromocodeError;
        final String promocodeErrorMessage = ref.watch(settingsProvider).promocodeErrorMessage;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomText(
              text: "Информация о реферальной ссылке",
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
            5.verticalSpace,
            if (isPromocodeSuccess)
            RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Промокод успешно применен : ',
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: newPromocodeDescription,
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            if (isPromocodeError)
            RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Ошибка применения промокода :',
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: promocodeErrorMessage,
                      style: GoogleFonts.raleway(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.redText,
                      ),
                    ),
                  ],
                ),
              ),
            
            10.verticalSpace,
            CustomButton(
              onPressed: () {
                /* if (isPromocodeError) {
                  ref.read(settingsProvider.notifier).cleanLastPromocodeError();
                } */
                context.router.pop();
              },
              text: "Назад",
              height: 40.h,
              buttonColor: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        );
      },
    ),
  );
}