import 'package:activity/application/activity/activity_notifier.dart';
import 'package:activity/application/activity/activity_state.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class TheOneWithImage extends StatelessWidget {
  final ActivityState state;
  final ActivityNotifier event;

  const TheOneWithImage({Key? key, required this.state, required this.event})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200.h,
          width: double.maxFinite,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black,
                Colors.transparent,
                Colors.transparent,
                Colors.black,
              ],
              stops: [
                0.07,
                0.5,
                0.77,
                1.0,
              ],
            ),
          ),
          child: CachedNetworkImage(
            imageUrl: state.gym?.mainPictureUrl ?? "",
            errorWidget: (context, url, error) {
              return Image.asset(
                "assets/images/avatar.png",
                fit: BoxFit.cover,
              );
            },
            fit: BoxFit.cover,
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Padding(
            padding: EdgeInsets.only(top: 15.h, left: 15.w),
            child: Row(
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 40.w,
                    height: 40.h,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(left: 5.w),
                      child: Icon(
                        Icons.arrow_back_ios,
                        size: 17.r,
                      ),
                    ),
                  ),
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 300.w,
                      child: CustomText(
                        color: Colors.white,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        fontSize: 19.sp,
                        fontWeight: FontWeight.w600,
                        //text: "xmskskmsmsmxskmskxmsksmksmxskmskxsmcmkemekcmekcmekm",
                        text: state.gym?.name ?? "",
                      ),
                    ),
                    5.verticalSpace,
                    SizedBox(
                      width: 300.w,
                      child: CustomText(
                        color: Colors.white,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                        fontSize: 16.sp,
                        //text: "Москва",
                        text: state.gym?.description ?? "",
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 15.w, bottom: 15.h),
              child: Row(
                children: [
                  SizedBox(
                      width: 18.w,
                      height: 18.h,
                      child: SvgPicture.asset(
                        "assets/svg/location.svg",
                        fit: BoxFit.cover,
                      )),
                  7.horizontalSpace,
                  CustomText(
                    color: Colors.white,
                    text: state.gym?.address ?? "",
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
