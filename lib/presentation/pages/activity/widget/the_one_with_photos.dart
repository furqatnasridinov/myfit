import 'package:myfit/application/activity/activity_notifier.dart';
import 'package:myfit/application/activity/activity_provider.dart';
import 'package:myfit/infrastructure/services/app_colors.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/presentation/components/components.dart';
import 'package:myfit/presentation/pages/activity/skeletons/photos_skeleton.dart';
import 'package:myfit/presentation/router/app_router.gr.dart';
import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TheOneWithPhotos extends StatelessWidget {
  final ActivityNotifier event;
  const TheOneWithPhotos({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Consumer(builder: (context, ref, child) {
      final photosOfSelectedActivity = ref.watch(activityProvider).photosOfSelectedActivity;
      final loading = ref.watch(activityProvider).isPhotosLoading;
      //if (photosOfSelectedActivity.isEmpty && !loading) return const SizedBox();
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: loading ? const PhotosSkeleton() : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            32.verticalSpace,
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
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: photosOfSelectedActivity.length,
                itemBuilder: (context, index) {
                  final current = photosOfSelectedActivity[index];
                  String linkToCompressedPhoto =
                      event.getLinkToCompressedPhoto(current);
                  return InkWell(
                    onTap: () {
                      context.router.push(PhotoViewRoute(
                        index: index,
                        photos: photosOfSelectedActivity,
                      ));
                    },
                    child: Padding(
                      padding: EdgeInsets.only(right: 10.w),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: SizedBox(
                          //color: Colors.red,
                          width: 47.w,
                          height: 47.h,
                          child: Hero(
                            tag: index,
                            child: CachedNetworkImage(
                              imageUrl:"http://77.222.53.122/image/$linkToCompressedPhoto",
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) {
                                return Image.asset(AppConstants.cristianBale);
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      );
    });
  }
}
