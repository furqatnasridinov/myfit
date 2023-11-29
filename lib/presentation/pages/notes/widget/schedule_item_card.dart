import 'package:flutter/material.dart';

class ScheduleItemCard extends StatelessWidget {
  const ScheduleItemCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
    
    /* Column(
      children: [
        Card(
          color: const Color.fromRGBO(89, 154, 254, 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.r),
            child: Column(
              children: [
                Row(children: [
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        color: Colors.white,
                        size: 16.r,
                      ),
                      5.horizontalSpace,
                      InterText(
                        text: 'Welness Centre',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      Icon(
                        Icons.schedule_outlined,
                        color: Colors.white,
                        size: 16.r,
                      ),
                      5.horizontalSpace,
                      InterText(
                        text: '12:45',
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    ],
                  )
                ]),
                // bottom part
                10.verticalSpace,
                Row(
                  children: [
                    Icon(
                      Icons.flash_on_outlined,
                      color: Colors.white,
                      size: 16.r,
                    ),
                    5.horizontalSpace,
                    Expanded(
                      child: InterText(
                        text: " Тренажёрный зал. Занятие с тренером",
                        fontWeight: FontWeight.w400,
                        fontSize: 13.sp,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        1.verticalSpace,
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                border:
                    Border.all(color: const Color.fromRGBO(233, 233, 233, 1)),
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white,
              ),
              child: SizedBox(
                width: 81.w,
                child: InterText(
                  text: 'Массаж не очень',
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            5.horizontalSpace,
            Expanded(
                child: Container(
              padding: EdgeInsets.all(16.r),
              decoration: BoxDecoration(
                border: Border.all(
                  color: const Color.fromRGBO(233, 233, 233, 1),
                ),
                borderRadius: BorderRadius.circular(8.r),
                color: Colors.white,
              ),
              child: SizedBox(
                width: 81.w,
                child: InterText(
                  text:
                      'Странно хрустнуло в спине, когда позвоночник проминали. Теперь болит',
                  fontWeight: FontWeight.w400,
                  fontSize: 13.sp,
                ),
              ),
            ))
          ],
        ),
        5.verticalSpace,
        OutlinedButton(
          onPressed: () {},
          style: OutlinedButton.styleFrom(
              minimumSize: const Size.fromHeight(50),
              side: BorderSide(
                width: 1.w,
                color: const Color.fromRGBO(89, 154, 254, 1),
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              )),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomText(
                text: 'Добавить',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
              ),
              10.horizontalSpace,
              Icon(
                Icons.add,
                size: 18.r,
                color: Colors.black,
              ),
            ],
          ),
        ),
      ],
    ); */
  }
}
