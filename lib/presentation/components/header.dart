import 'package:activity/presentation/components/ui_button_filled.dart';
import 'package:flutter/material.dart';
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
        hideOverlay();
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
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      title: _headerSearchBar(),

      // Если обратный роутер указан, то он отрисовывается
      leading: widget.backRoute != '' && isSearchBarOpened == false
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
      margin: const EdgeInsets.only(top: 10.0, left: 16.0),
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(
              color: const Color.fromRGBO(233, 233, 233, 1), width: 1),
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(500.0),
          //onTap: () => {context.go(router)},
          child: Container(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 7.0, right: 9.0),
            child: const Icon(
              Icons.keyboard_arrow_left,
              size: 24.0,
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
          height: 294.0,
          margin: const EdgeInsets.only(left: 16.0, top: 2.5, right: 16.0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              color: Colors.white,
              border: Border.all(
                  width: 1.0, color: Color.fromRGBO(119, 170, 249, 1))),
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column(children: [
            Expanded(
              child: ListView(shrinkWrap: true, children: [
                ListTile(
                    title: Text(
                      'TEXT TEST',
                      //style: MyFitAppFonts.label2(MyFitAppColors.txtBlack),
                    ),
                    subtitle: Text('234м от вас От 1000 ₽')),
                ListTile(
                  title: Text(
                    'TEXT TEST',
                    //style: MyFitAppFonts.label2(MyFitAppColors.txtBlack),
                  ),
                  subtitle: Text('234м от вас От 1000 ₽'),
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
                    title: Text(
                      'TEXT TEST',
                      //style: MyFitAppFonts.label2(MyFitAppColors.txtBlack),
                    ),
                    subtitle: Text('234м от вас От 1000 ₽')),
                ListTile(
                    title: Text(
                      'TEXT TEST',
                      //style: MyFitAppFonts.label2(MyFitAppColors.txtBlack),
                    ),
                    subtitle: Text('234м от вас От 1000 ₽')),
                ListTile(
                    title: Text(
                      'TEXT TEST',
                      //style: MyFitAppFonts.label2(MyFitAppColors.txtBlack),
                    ),
                    subtitle: Text('234м от вас От 1000 ₽')),
              ]),
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
        padding: const EdgeInsets.only(top: 9.0),
        child: Stack(
          children: [
            TapRegion(
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(100.0),
                    border: Border.all(
                        color: isSearchBarOpened
                            ? const Color.fromRGBO(119, 170, 249, 1)
                            : const Color.fromRGBO(233, 233, 233, 1),
                        width: 1.0)),
                height: 40.0,
                padding: const EdgeInsets.only(
                    top: 6.0, bottom: 6.0, left: 8.0, right: 22.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(100.0),
                      child: Container(
                        color: const Color.fromRGBO(245, 249, 255, 1),
                        padding: const EdgeInsets.all(5.0),
                        child: const Icon(
                          Icons.search,
                          color: Color.fromRGBO(62, 134, 245, 1),
                          size: 18.0,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10.0),
                    Flexible(
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
                                ? const Icon(
                                    Icons.close,
                                    size: 24.0,
                                    color: Color.fromRGBO(37, 37, 37, 1),
                                  )
                                : const SizedBox.shrink(),
                            border: InputBorder.none,
                            hintText: 'Найти занятие',
                            hintStyle: TextStyle(
                                fontSize: 14.0,
                                color: Color.fromRGBO(176, 176, 176, 1)),
                            contentPadding: EdgeInsets.only(bottom: 19.0)),
                        style: const TextStyle(
                            fontSize: 14.0,
                            color: Color.fromRGBO(37, 37, 37, 1)),
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
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100.0),
          border: Border.all(
              color: const Color.fromRGBO(233, 233, 233, 1), width: 1),
          color: Colors.white,
        ),
        margin: const EdgeInsets.only(top: 10.0, right: 16.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 8.0, bottom: 8.0),
              child: GestureDetector(
                child: SvgPicture.asset(
                  'lib/assets/icons/calendar.svg',
                  width: 24.0,
                  height: 24.0,
                ),
                //onTap: () => {context.go('/schedule')},
              ),
            ),
            const SizedBox(width: 12.0),
            SizedOverflowBox(
              size: const Size(40, 40),
              child: CircleAvatar(
                radius: 100.0,
                backgroundColor: const Color.fromRGBO(119, 170, 249, 1),
                child: Padding(
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                      child: Image.network(
                          'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg')),
                ),
              ),
            ),
          ],
        ));
  }
}
