import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:rive/rive.dart';

import 'package:iclavis/personalizacion.dart';

class _WaitAnimation extends StatefulWidget {
  @override
  _WaitAnimationState createState() => _WaitAnimationState();
}

class _WaitAnimationState extends State<_WaitAnimation> {
  Artboard? _riveArtboard;
  RiveAnimationController? _controller;

  @override
  void initState() {
    rootBundle.load('assets/animations/wait_animation.riv').then((bytes) {
      final file = RiveFile.import(bytes);
      _riveArtboard = file.mainArtboard
        ..forEachChild((c) {
          if (Customization.personalizable) {
            if (c is Shape) {
              if (true /* c.name == 'Custom Shape' */) {
                c.strokes.forEach((e) {
                  e.paint.color = Customization.variable_1;
                });
              }
            }
          }

          return true;
        })
        ..addController(
          _controller = SimpleAnimation('Untitled 1'),
        );

      setState(() => _controller?.isActive = true);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _riveArtboard == null
        ? SizedBox()
        : Rive(
            artboard: _riveArtboard!,
            fit: BoxFit.contain,
          );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

final _animation = OverlayEntry(builder: (_) {
  return _WaitAnimation();
});

void showWaitAnimation(BuildContext context) {
  Overlay.of(context)?.insert(_animation);
}

void removeWaitAnimation() => _animation.remove();
