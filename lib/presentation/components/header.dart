import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_text.dart';
import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

class Header extends StatefulWidget implements PreferredSizeWidget {
  // Название в шапке
  // final String headerTitle;

  // Ссылка на обратную страницу
  final String backRoute;

  const Header({
    Key? key,
    // this.headerTitle = '',
    this.backRoute = '',
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(60.0);

  @override
  State<Header> createState() => _Header();
}

class _Header extends State<Header> {
  bool isSearchBarOpened = false;

  late TextEditingController _searchController;

  final layerLink = LayerLink();
  OverlayEntry? entry;
  final focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    _searchController = TextEditingController();

    // WidgetsBinding.instance.addPostFrameCallback((_) => showOverlay());

    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        showOverlay();
      } else {
        // hideOverlay();
      }
    });
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
    // final offset = renderBox.localToGlobal(Offset.zero);

    entry = OverlayEntry(
        builder: (context) => Positioned(
            // left: offset.dx,
            // top: offset.dy + size.height + 2.5,
            width: size.width,
            child: CompositedTransformFollower(
                offset: Offset(-15, size.height + 2.5),
                link: layerLink,
                child: _listItems())));

    overlay.insert(entry!);
  }

  void hideOverlay() {
    entry?.remove();
    entry = null;
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      //backgroundColor: Colors.red,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: _headerSearchBar(),

      // Если обратный роутер указан, то он отрисовывается
      leading: /* widget.backRoute != '' &&  */ isSearchBarOpened == false
          ? _headerBackButton(widget.backRoute, context)
          : null,

      actions: [
        isSearchBarOpened == false
            ? _headerActions(context)
            : const SizedBox.shrink()
      ],
    );
  }

  _headerBackButton(String router, BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.h, left: 16.w),
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
          borderRadius: BorderRadius.circular(500.r),
          //onTap: () => {context.go(router)},
          child: SizedBox(
            child: Icon(
              Icons.keyboard_arrow_left,
              size: 24.r,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  _listItems() {
    return Material(
      color: Colors.transparent,
      child: TapRegion(
        child: Container(
          height: 294.h,
          margin: EdgeInsets.only(left: 16.w, top: 2.5.h, right: 16.w),
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
          child: Column(children: [
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
                        focusNode.unfocus();
                        setState(() {
                          isSearchBarOpened = false;
                        });
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
          ]),
        ),
        onTapOutside: (tap) {
          hideOverlay();
          focusNode.unfocus();
          setState(() {
            isSearchBarOpened = false;
          });
        },
      ),
    );
  }

  _headerSearchBar() {
    return CompositedTransformTarget(
      link: layerLink,
      child: Padding(
        padding: EdgeInsets.only(top: 9.h),
        child: Stack(
          children: [
            TapRegion(
              child: Container(
                decoration: BoxDecoration(
                  //color: Colors.green,
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(100.r),
                  border: Border.all(
                    color: isSearchBarOpened
                        ? const Color.fromRGBO(119, 170, 249, 1)
                        : const Color.fromRGBO(233, 233, 233, 1),
                    width: 1.w,
                  ),
                ),
                height: 40.h,
                padding: EdgeInsets.only(
                  top: 6.h,
                  bottom: 6.h,
                  left: 8.w,
                  right: 22.w,
                ),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.r),
                      child: Container(
                        color: const Color.fromRGBO(245, 249, 255, 1),
                        padding: EdgeInsets.all(5.r),
                        child: Icon(
                          Icons.search,
                          color: const Color.fromRGBO(62, 134, 245, 1),
                          size: 18.r,
                        ),
                      ),
                    ),
                    10.horizontalSpace,
                    Flexible(
                      child: Container(
                        //padding: EdgeInsets.only(top: 14.h),
                        //color: Colors.amber,
                        child: TextField(
                          controller: _searchController,
                          focusNode: focusNode,
                          maxLines: 1,
                          onChanged: (String val) {
                            if (val.length > 0) {
                              print('123');
                            }
                          },
                          decoration: InputDecoration(
                            suffixIcon: isSearchBarOpened == true
                                ? InkWell(
                                    onTap: () {
                                      _searchController.clear();
                                      focusNode.unfocus();
                                      hideOverlay();
                                      isSearchBarOpened = false;
                                      setState(() {});
                                    },
                                    child: Icon(
                                      Icons.close,
                                      size: 24.r,
                                      color:
                                          const Color.fromRGBO(37, 37, 37, 1),
                                    ),
                                  )
                                : const SizedBox.shrink(),
                            border: InputBorder.none,
                            hintText: 'Найти занятие',
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
                    ),
                  ],
                ),
              ),
              onTapInside: (tap) {
                setState(() {
                  isSearchBarOpened = true;
                });
              },
            ),
            const SizedBox(height: 2.5),
          ],
        ),
      ),
    );
  }

  _headerActions(BuildContext context) {
    return Container(
        height: 40.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.r),
          border: Border.all(
            color: const Color.fromRGBO(233, 233, 233, 1),
            width: 1.w,
          ),
          color: Colors.white,
        ),
        margin: EdgeInsets.only(top: 10.h, right: 16.w),
        child: Row(
          children: [
            Padding(
              padding:  EdgeInsets.only(
                left: 20.w,
                top: 8.h,
                bottom: 8.h,
              ),
              child: GestureDetector(
                child: SvgPicture.asset(
                  "assets/svg/calendar.svg",
                  width: 24.w,
                  height: 24.h,
                ),
                //onTap: () => {context.go('/schedule')},
              ),
            ),
            10.horizontalSpace,
            SizedOverflowBox(
              size: Size(40.w, 40.h),
              child: CircleAvatar(
                radius: 100.r,
                backgroundColor: const Color.fromRGBO(119, 170, 249, 1),
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
        ));
  }
}
