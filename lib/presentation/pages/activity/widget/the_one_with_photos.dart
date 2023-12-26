import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_provider.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/infrastructure/services/app_constants.dart';
import 'package:activity/presentation/components/components.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithPhotos extends StatelessWidget {
  final ActivityNotifier event;
  const TheOneWithPhotos({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "Фотографии",
            fontWeight: FontWeight.w600,
            fontSize: 16.sp,
            color: Colors.black,
          ),
          10.verticalSpace,
          Container(
            padding: EdgeInsets.all(16.r),
            width: double.maxFinite,
            height: 79.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              color: Colors.white,
              border: Border.all(
                color: AppColors.greyBorder,
                width: 1.w,
              ),
            ),
            child: Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(activityProvider);
                return ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: state.photosOfSelectedActivity.length,
                  itemBuilder: (context, index) {
                    final current = state.photosOfSelectedActivity[index];
                    return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return Dialog(
                              backgroundColor: Colors.black.withOpacity(0.5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15.r),
                              ),
                              child: SizedBox(
                                //color: Colors.red,
                                height: 330.h,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      "http://77.222.53.122/image/$current",
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) {
                                    return Image.asset(
                                        AppConstants.cristianBale);
                                  },
                                ),
                              ),
                            );
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 10.w),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.r),
                          child: SizedBox(
                            //color: Colors.red,
                            width: 47.w,
                            height: 47.h,
                            child: CachedNetworkImage(
                              imageUrl: "http://77.222.53.122/image/$current",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Image.asset(AppConstants.cristianBale);
                              },
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
