// ignore_for_file: public_member_api_docs, sort_constructors_first, deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:activity/application/schedule/schedule_notifier.dart';
import 'package:activity/application/schedule/schedule_state.dart';
import 'package:activity/infrastructure/models/data/gym_with_tags.dart';
import 'package:activity/infrastructure/services/app_colors.dart';
import 'package:activity/presentation/components/custom_button.dart';
import 'package:activity/presentation/components/custom_card.dart';
import 'package:activity/presentation/components/custom_textfield.dart';
import 'package:activity/presentation/components/custom_textformfield.dart';
import 'package:activity/presentation/components/inter_text.dart';

// ignore: must_be_immutable
class NotesCardMaker extends StatefulWidget {
  final ScheduleNotifier event;
  ScheduleState state;
  final String name;
  final String startTime;
  final String description;
  final String day;
  final GymWithTags gymWithTags;
  NotesCardMaker({
    Key? key,
    required this.event,
    required this.state,
    required this.name,
    required this.startTime,
    required this.description,
    required this.day,
    required this.gymWithTags,
  }) : super(key: key);

  @override
  State<NotesCardMaker> createState() => _NotesCardMakerState();
}

class _NotesCardMakerState extends State<NotesCardMaker> {
  TextEditingController tagController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode tagFocus = FocusNode();
  FocusNode descriptionFocus = FocusNode();
  List<GymWithTags> addedNotes = [];

  @override
  Widget build(BuildContext context) {
    List<String> parts = widget.day.split("@"); //2023-11-11@15:15
    String dayToFormat = parts[0]; //2023-11-11
    final formattedDay = widget.event.formatDay(dayToFormat); // Ноябрь 11
    if (addedNotes.isNotEmpty) {
    }
    return Container(
      margin: EdgeInsets.only(bottom: 32.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // date and time
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: "Заметки на",
                  style: GoogleFonts.raleway(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
                WidgetSpan(
                  child: SizedBox(
                    width: 5.w,
                  ),
                ),
                TextSpan(
                  text: formattedDay,
                  style: GoogleFonts.raleway(
                    color: AppColors.blueColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 20.sp,
                  ),
                ),
              ],
            ),
          ),

          32.verticalSpace,
          // blue container
          CustomCard(
            color: AppColors.blueColor,
            child: Column(
              children: [
                // top section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // location
                    SizedBox(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/location.svg",
                            color: Colors.white,
                            width: 16.w,
                            height: 16.h,
                          ),
                          3.horizontalSpace,
                          SizedBox(
                            //color: Colors.amber,
                            width: 210.w,
                            child: InterText(
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                              text: widget.name,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.white,
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            "assets/svg/clock.svg",
                            color: Colors.white,
                          ),
                          3.horizontalSpace,
                          InterText(
                            text: widget.startTime
                                .substring(widget.startTime.length - 5),
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w400,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ],
                ),

                10.verticalSpace,

                // botoom section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      child: SvgPicture.asset(
                        "assets/svg/activity.svg",
                        color: Colors.white,
                        width: 16.w,
                        height: 16.h,
                      ),
                    ),
                    3.horizontalSpace,
                    Flexible(
                      child: SizedBox(
                        width: 290.w,
                        child: InterText(
                          text: widget.description,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),

          5.verticalSpace,
          // texfields
          _textFieldsBuilder(
            context,
            widget.gymWithTags.id!,
          ),
        ],
      ),
    );
  }

  Widget _textFieldsBuilder(BuildContext context, int id) {
    return Column(
      children: [
        // textfields
        MediaQuery.removePadding(
          context: context,
          removeBottom: true,
          child: ListView.builder(
            itemCount: widget.gymWithTags.tag?.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final currentTag = widget.gymWithTags.tag?[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      //color: Colors.red,
                      width: 113.w,
                      child: CustomTextFormField(
                        readOnly: true,
                        initialValue: currentTag?.tag,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.w,
                          horizontal: 5.h,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 225.w,
                      child: CustomTextFormField(
                        readOnly: true,
                        initialValue: currentTag?.description,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 10.w,
                          horizontal: 5.h,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),

        // added notes part
        MediaQuery.removePadding(
          context: context,
          removeTop: true,
          removeBottom: true,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: addedNotes.length,
            itemBuilder: (context, index) {
              final current = addedNotes[index].tag;
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Column(
                  children: current?.map((tag) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              //color: Colors.red,
                              width: 113.w,
                              child: CustomTextFormField(
                                readOnly: true,
                                initialValue: tag.tag,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.w,
                                  horizontal: 5.h,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 225.w,
                              child: CustomTextFormField(
                                readOnly: true,
                                initialValue: tag.description,
                                keyboardType: TextInputType.multiline,
                                maxLines: null,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.w,
                                  horizontal: 5.h,
                                ),
                              ),
                            ),
                          ],
                        );
                      }).toList() ??
                      [],
                ),
              );
            },
          ),
        ),

        // input textfields
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              //color: Colors.red,
              width: 113.w,
              child: CustomTextField(
                onTap: () {
                  tagFocus.requestFocus();
                  setState(() {});
                },
                focusNode: tagFocus,
                controller: tagController,
                hintText: "Заметка",
                keyboardType: TextInputType.multiline,
                maxLines: null,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.w,
                  horizontal: 5.h,
                ),
              ),
            ),
            SizedBox(
              width: 225.w,
              child: CustomTextField(
                onTap: () {
                  descriptionFocus.requestFocus();
                  setState(() {});
                },
                focusNode: descriptionFocus,
                controller: descriptionController,
                hintText: "Описание",
                keyboardType: TextInputType.multiline,
                maxLines: null,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.w,
                  horizontal: 5.h,
                ),
              ),
            ),
          ],
        ),
        10.verticalSpace,

        // button
        CustomButton(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          onPressed: () {
            if (tagController.text.length > 1 &&
                descriptionController.text.length > 1) {
              widget.event
                  .addNote(
                tagController.text,
                descriptionController.text,
                id,
                context,
              )
                  .then((value) {
                // Clear text fields
                // Add the new note to the addedNotes list
                addedNotes.add(
                  widget.gymWithTags.copyWith(
                    tag: [
                      Tag(
                        tag: tagController.text,
                        description: descriptionController.text,
                      )
                    ],
                  ),
                );
                tagController.clear();
                descriptionController.clear();
                tagFocus.requestFocus();
                // Trigger a rebuild for added notes only
                setState(() {});
              });
            } else {
              return;
            }
          },
          text: "Добавить +",
        ),
      ],
    );
  }
}
