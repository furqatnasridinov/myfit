import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class ScheduleHeader extends StatefulWidget {
  final ScheduleNotifier event;
  final ScheduleState state;
  const ScheduleHeader({super.key, required this.event, required this.state});

  @override
  State<ScheduleHeader> createState() => _ScheduleHeaderState();
}

class _ScheduleHeaderState extends State<ScheduleHeader> {
  late TextEditingController _searchController;
  final textFieldFocusNode = FocusNode();
  final layerLink = LayerLink();
  OverlayEntry? entry;
  bool isSearchbarOpened = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _searchController = TextEditingController();
    textFieldFocusNode.addListener(
      () {
        if (textFieldFocusNode.hasFocus) {
          showOverlay();
          print("focusnode has focus");
        } else {
          print("focusnode has no focus");
          hideOverlay();
        }
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
      builder: (context) => Positioned(
        left: offset.dx,
        top: offset.dy + size.height + 2.5,
        width: size.width,
        child: CompositedTransformFollower(
          offset: Offset(0, size.height + 2.5),
          link: layerLink,
          showWhenUnlinked: false,
          child: _listItems(),
        ),
      ),
    );

    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      height: 40.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      //color: Colors.red,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // back button
          textFieldFocusNode.hasFocus
              ? const SizedBox()
              : SizedBox(
                  width: 40.w,
                  height: 40.h,
                  child: Ink(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: const Color.fromRGBO(233, 233, 233, 1),
                        width: 1.w,
                      ),
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: InkWell(
                      onTap: () => context.popRoute(),
                      borderRadius: BorderRadius.circular(500.r),
                      child: SizedBox(
                        child: Icon(
                          Icons.keyboard_arrow_left,
                          size: 24.r,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),

          // main search field
          Container(
            width: textFieldFocusNode.hasFocus ? 340.w : 200.w,
            decoration: BoxDecoration(
              //color: Colors.green,
              color: Colors.white,
              borderRadius: BorderRadius.circular(100.r),
              border: Border.all(
                color: textFieldFocusNode.hasFocus
                    ? const Color.fromRGBO(119, 170, 249, 1)
                    : const Color.fromRGBO(233, 233, 233, 1),
                width: 1.w,
              ),
            ),
            padding: EdgeInsets.only(left: 10.w),
            child: TextField(
              onTap: () {
                //textFieldFocusNode.requestFocus();
                //showOverlay();
                setState(() {});
              },
              onTapOutside: (event) {
                textFieldFocusNode.unfocus();
                //hideOverlay();
                setState(() {});
              },
              controller: _searchController,
              focusNode: textFieldFocusNode,
              maxLines: 1,
              onChanged: (String val) {
                if (val.length > 0) {
                  print('123');
                }
              },
              decoration: InputDecoration(
                //contentPadding: EdgeInsets.zero,
               /*  prefix: Container(
                  width: 28.w,
                  height: 28.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    //color: Color.fromRGBO(245, 249, 255, 1),
                    color: Colors.red
                  ),
                ), */
                suffixIcon: textFieldFocusNode.hasFocus
                    ? InkWell(
                        onTap: () {
                          _searchController.clear();
                          //textFieldFocusNode.unfocus();
                          //hideOverlay();
                          //isSearchBarOpened == false;
                          setState(() {});
                        },
                        child: Icon(
                          Icons.close,
                          size: 24.r,
                          color: const Color.fromRGBO(37, 37, 37, 1),
                        ),
                      )
                    : const SizedBox.shrink(),
                border: InputBorder.none,
                hintText: 'Занятие, зал',
                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: const Color.fromRGBO(
                    176,
                    176,
                    176,
                    1,
                  ),
                ),
                //contentPadding: EdgeInsets.zero,
              ),
              style: TextStyle(
                fontSize: 14.r,
                color: const Color.fromRGBO(
                  37,
                  37,
                  37,
                  1,
                ),
              ),
            ),
          ),

          // actions part
          textFieldFocusNode.hasFocus
              ? const SizedBox()
              : Container(
                  width: 96.w,
                  height: 40.h,
                  padding: EdgeInsets.only(left: 20.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100.r),
                    border: Border.all(
                      color: const Color.fromRGBO(233, 233, 233, 1),
                      width: 1.w,
                    ),
                    color: Colors.white,
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        child: SvgPicture.asset(
                          "assets/svg/pencil.svg",
                          width: 24.w,
                          height: 24.h,
                        ),
                        //onTap: () => {context.go('/schedule')},
                      ),
                      10.horizontalSpace,
                      SizedOverflowBox(
                        size: Size(40.w, 40.h),
                        child: CircleAvatar(
                          radius: 100.r,
                          backgroundColor:
                              const Color.fromRGBO(119, 170, 249, 1),
                          child: Padding(
                            padding: EdgeInsets.all(2.r),
                            child: ClipOval(
                              child: Image.network(
                                'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ],
      ),
    );
  }

  _listItems() {
    return Material(
      color: Colors.red,
      child: Container(
        height: 294.h,
        margin: EdgeInsets.only(left: 16.w, /* top: 100.h, */ right: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: Colors.white,
          border: Border.all(
            width: 1.w,
            color: const Color.fromRGBO(
              119,
              170,
              249,
              1,
            ),
          ),
        ),
        padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.0.h),
        child: Column(
          children: [
            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ListTile(
                      title: CustomText(text: 'TEXT TEST'),
                      subtitle: CustomText(
                        text: '234м от вас От 1000 ₽',
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    ListTile(
                      title: CustomText(text: 'TEXT TEST'),
                      subtitle: CustomText(
                        text: '234м от вас От 1000 ₽',
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                      onTap: () {
                        _searchController.text = 'Text test';
                        hideOverlay();
                        textFieldFocusNode.unfocus();
                        isSearchbarOpened = false;
                        setState(() {});
                      },
                    ),
                    ListTile(
                      title: CustomText(text: 'TEXT TEST'),
                      subtitle: CustomText(
                        text: '234м от вас От 1000 ₽',
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    ListTile(
                      title: CustomText(text: 'TEXT TEST'),
                      subtitle: CustomText(
                        text: '234м от вас От 1000 ₽',
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                    ListTile(
                      title: CustomText(text: 'TEXT TEST'),
                      subtitle: CustomText(
                        text: '234м от вас От 1000 ₽',
                        fontWeight: FontWeight.w300,
                        fontSize: 14.sp,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10.0),
            UiButtonFilled(
              btnText: 'Показать на карте',
              onPressedAction: () => print('123'),
              isFullWidth: true,
            )
          ],
        ),
      ),
    );
  }
}
