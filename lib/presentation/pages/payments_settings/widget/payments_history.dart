import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:myfit/infrastructure/models/data/payment.dart';
import 'package:myfit/infrastructure/services/app_constants.dart';
import 'package:myfit/infrastructure/services/apphelpers.dart';
import 'package:myfit/presentation/components/custom_text.dart';
import 'package:myfit/presentation/components/dummy_data.dart';

class PaymentsHistory extends StatelessWidget {
  const PaymentsHistory({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Payment> list = DummyData.payments;
    list.sort((a, b) => b.date!.compareTo(a.date!));
    final Map<String, List<Payment>> grouped = {};
    for (var payment in list) {
      final String formattedDate =
          AppHelpers.formatDateTimeToString(payment.date ?? DateTime.now());
      if (grouped.containsKey(formattedDate)) {
        grouped[formattedDate]?.add(payment);
      } else {
        grouped[formattedDate] = [payment];
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomText(
            text: "История списаний",
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
          16.verticalSpace,
          ListView.builder(
            itemCount: grouped.keys.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final String date = grouped.keys.elementAt(index);
              final List<Payment> payments = grouped[date]!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomText(
                    text: date,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  8.verticalSpace,
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: payments.length,
                    itemBuilder: (context, index) {
                      final Payment payment = payments[index];
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.w),
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 20.r,
                              backgroundColor: Colors.grey,
                              backgroundImage: NetworkImage(
                                  "${AppConstants.baseUrl}/image/${payment.pic}"),
                            ),
                            10.horizontalSpace,
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CustomText(
                                    text: payment.source ?? "",
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.1,
                                  ),
                                  CustomText(
                                    text: payment.description ?? "",
                                    fontSize: 14.sp,
                                    height: 1.1,
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                CustomText(
                                  text: "- ${payment.amount} ₽",
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w700,
                                  height: 1.1,
                                ),
                                 CustomText(
                                  text: AppHelpers.getCalendarlikeStringFromDateTime(payment.date ?? DateTime.now(), fullYear: false),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.1,
                                ),
                                CustomText(
                                  text: AppHelpers.getTimeAndMinuteFromDt(payment.date ?? DateTime.now()),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                  height: 1.1,
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  16.verticalSpace,
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
