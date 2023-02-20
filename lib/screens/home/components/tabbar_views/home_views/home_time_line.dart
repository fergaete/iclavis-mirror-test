import 'package:flutter/material.dart';

import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/personalizacion.dart';

import 'styles.dart';

final _styles = HomeViewsStyles();

class HomeTimeLine extends StatelessWidget {
  final int milestoneCompleted;
  final Color colorCompleted;
  final int postSale;

  HomeTimeLine(
      {Key? key,
      required this.milestoneCompleted,
      required this.colorCompleted,
      this.postSale = 0})
      : super(key: key);

  final double circleSize = 20.w;
  final double timelineWidth = 261.w;
  final double timelineHeight = 2.w;

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    final milestones = [
      i18n("home.quotation_timeline"),
      i18n("home.reservation_timeline"),
      i18n("home.promise_timeline"),
      i18n("home.writing_timeline"),
      i18n("home.delivery_timeline"),
    ];

    return (postSale == 0 || postSale == 1)
        ? timeLineWidget(milestones, i18n("home.aftersales_timeline"))
        : timeLinePostLineWidget(
            milestones, postSale, i18n("home.aftersales_timeline"));
  }

  Widget timeLineWidget(List<String> milestones, String postSaleText) {
    List<bool> isMilestoneCompleted = [];
    double completedWidth = 0;
    if (postSale == 1) {
      milestones.add(postSaleText);
      isMilestoneCompleted = List.filled(6, false);
      isMilestoneCompleted.fillRange(0, 3, true);
      completedWidth = timelineWidth /
          (milestones.length - 1) *
          (milestoneCompleted == 0 ? 0 : 3 - 1);
    } else {
      isMilestoneCompleted = List.filled(5, false);
      isMilestoneCompleted.fillRange(0, milestoneCompleted, true);
      completedWidth = timelineWidth /
          (milestones.length - 1) *
          (milestoneCompleted == 0 ? 0 : milestoneCompleted - 1);
    }

    return Container(
      width: timelineWidth + 45.w,
      height: circleSize + 22.h + 12.sp,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Positioned(
            top: circleSize / 2,
            left: 10.sp * milestones.length / 2,
            child: CustomPaint(
              size: Size(timelineWidth, timelineHeight),
              painter: Rectangle(
                completedWidth: completedWidth,
                colorCompleted: colorCompleted,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              milestones.length,
              (i) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: _styles.circleShape(
                      isMilestoneCompleted[i],
                      colorCompleted,
                    ),
                    child: Center(
                      child: isMilestoneCompleted[i] == true
                          ? Icon(
                              Icons.check,
                              size: 10.sp,
                              color: Customization.variable_4,
                            )
                          : Text(
                              (i + 1).toString(),
                              textScaleFactor: 1.0,
                              style: _styles.mediumText(
                                  10.sp, Customization.variable_2),
                            ),
                    ),
                  ),
                  Text(
                    milestones[i],
                    textScaleFactor: 1.0,
                    maxLines: 1,
                    style: isMilestoneCompleted[i]
                        ? _styles.lightText(10.sp, Customization.variable_2)
                        : _styles.lightText(10.sp, Color(0xff2f2f2f)),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget timeLinePostLineWidget(
      List<String> milestones, int postSale, String postSaleText) {
    milestones.add(postSaleText);
    final completedWidth =
        timelineWidth / (milestones.length - 1) * (5 == 0 ? 0 : 5 - 1);

    return Container(
      width: timelineWidth + 45.w,
      height: circleSize + 22.h + 10.sp,
      alignment: Alignment.center,
      child: Stack(
        children: [
          Positioned(
            top: circleSize / 2,
            left: 10.sp * milestones.length / 2,
            child: CustomPaint(
              size: Size(timelineWidth, timelineHeight),
              painter: Rectangle(
                completedWidth: completedWidth,
                colorCompleted: colorCompleted,
                colorBase: Customization.variable_1,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              milestones.length,
              (i) => Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: circleSize,
                    height: circleSize,
                    decoration: _styles.circleShape(
                      true,
                      i != 5 ? Colors.grey : Customization.variable_1,
                    ),
                    child: Center(
                        child: Icon(
                      Icons.check,
                      size: 10.sp,
                      color: Customization.variable_4,
                    )),
                  ),
                  Text(
                    milestones[i],
                    style: _styles.lightText(
                        10.sp,
                        i != 5
                            ? Customization.variable_2
                            : Customization.variable_1),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Rectangle extends CustomPainter {
  final double completedWidth;
  final Color colorCompleted;
  final Color? colorBase;
  Rectangle(
      {Key? key,
      required this.completedWidth,
      required this.colorCompleted,
      this.colorBase});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();

    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final advance = Rect.fromLTWH(0, 0, completedWidth, size.height);

    paint.color = (colorBase == null ? const Color(0xffe9e4dc) : colorBase)!;
    canvas.drawRect(rect, paint);

    paint.color = colorCompleted;
    canvas.drawRect(advance, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
