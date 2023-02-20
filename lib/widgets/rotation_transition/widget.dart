import 'package:flutter/material.dart';

AnimationController? _controller;

class RotationTransitionIcon extends StatefulWidget {
  final Icon child;
  final int duration;
  final double end;

  const RotationTransitionIcon({
    Key? key,
    required this.child,
    this.duration = 200,
    this.end = 0.5,
  })  : assert(end >= 0, end <= 1),
        super(key: key);

  @override
  _RotationTransitionIconState createState() => _RotationTransitionIconState();
}

class _RotationTransitionIconState extends State<RotationTransitionIcon>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    _controller = AnimationController(
      duration: Duration(milliseconds: widget.duration),
      vsync: this,
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: Tween(begin: 0.0, end: widget.end).animate(_controller!),
      child: GestureDetector(
        child: widget.child,
        onTap: () => setRotation(true),
      ),
    );
  }
}

void setRotation(bool isPanelOpen) {
  if (isPanelOpen) {
    _controller?.forward();
  } else {
    _controller?.reverse();
  }
}
