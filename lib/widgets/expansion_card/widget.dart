import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/shared/textstyles_shared.dart';

final _styles = TextStylesShared();

class ExpansionCard extends StatefulWidget {
  const ExpansionCard(
      {Key? key, this.leading, this.title,this.titleWidget, this.icon=false, this.child})
      : super(key: key);

  final Widget? leading;
  final String? title;
  final Widget? titleWidget;
  final bool icon;
  final Widget? child;

  @override
  State<ExpansionCard> createState() => _ExpansionCardState();
}

class _ExpansionCardState extends State<ExpansionCard>
    with TickerProviderStateMixin {
  bool expand = false;
  late AnimationController _animationController;
  @override
  void initState() {
    _animationController = AnimationController(
        duration: const Duration(milliseconds: 400), vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      padding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: expand ? 15.w : 0),
      decoration: const BoxDecoration(),
      duration: const Duration(milliseconds: 100),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                if (expand) {
                  expand = false;
                  _animationController.reverse(from: 0.5);
                } else {
                  expand = true;
                  _animationController.forward(from: 0.5);
                }
              });
            },
            child: Container(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  widget.leading ?? Container(),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                      child: widget.title!=null?Text(
                    widget.title ?? '',
                    textAlign: TextAlign.left,
                          style: _styles.lightText(14.sp),
                  ):widget.titleWidget!),
                  if(widget.icon)
                  RotationTransition(
                    turns:
                        Tween(begin: 0.0, end: 0.5).animate(_animationController),
                    child: Icon(
                      Icons.keyboard_arrow_down,
                      size: 15.w,
                    ),
                  )
                ],
              ),
            ),
          ),
          if (expand) widget.child ?? Container()
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
