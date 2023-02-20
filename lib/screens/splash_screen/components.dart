import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/blocs/first_start/first_start_bloc.dart';

import '../../blocs/authentication/authentication_bloc.dart';

import '../../routes/routes.dart';

class SplashScreenComponents extends StatefulWidget {
  const SplashScreenComponents({super.key});

  @override
  _SplashScreenComponentsState createState() => _SplashScreenComponentsState();
}

class _SplashScreenComponentsState extends State<SplashScreenComponents> {
  Artboard? _riveArtboard;
  RiveAnimationController? _controller;

  String routePath = '';
  String? notificationRoutePath;

  @override
  void didChangeDependencies() async {
    context.read<AuthenticationBloc>().add(AuthenticationSessionValidated());

    loadAnimation();
    /*  SharedPreferences prefs = await SharedPreferences.getInstance();

    notificationRoutePath = prefs.getString('notificationRoutePath');
    if (notificationRoutePath != null) {
      await prefs.setString('notificationRoutePath', 'null');
    }*/
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      child: _riveArtboard == null || kIsWeb
          ? Container(
              color: Customization.variable_2,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : GestureDetector(
              child: Rive(
                artboard: _riveArtboard!,
                fit: BoxFit.fill,
              ),
              onTap: () =>  GoRouter.of(context).pushNamed(
                   notificationRoutePath ?? routePath),
            ),
      listener: (_, state) {
        switch (state.status) {
          case AuthenticationStatus.authenticated:
            context.read<UserBloc>().add(UserLoaded());
            routeAuthenticated(true);
            break;
          default:
            context.read<FirstStartBloc>().add(FirstStartFlagLoaded());
            routeAuthenticated(false);
            break;
        }
      },
    );
  }

  void routeAuthenticated(bool isLogged) {
    if (isLogged) {
      setState(() {
        routePath = RouteName.PreHome;
        if (kIsWeb) {
          GoRouter.of(context).pushNamed(routePath);
        }
      });
    } else {
      setState(() {
        routePath = RouteName.Login;
        if (kIsWeb) {
          GoRouter.of(context).pushNamed(routePath);
        }
      });
    }
  }

  Future<void> loadAnimation() async {
    if (kIsWeb) return;
    String animationPath;

    if (Customization.personalizable) {
      animationPath = 'assets/animations/splashscreen-sinlogo.riv';
    } else {
      animationPath = 'assets/animations/new_splashscreen-iclavis-l.riv';
    }
    final bytes = await rootBundle.load(animationPath);
    final RiveFile file = RiveFile.import(bytes);

    _riveArtboard = file.mainArtboard
      ..forEachChild((c) {
        if (Customization.personalizable) {
          if (c is Shape) {
            if (c.name == 'SKY') {
              c.fills.first.paint.colorFilter = ColorFilter.mode(
                  Customization.variable_6.withOpacity(.9), BlendMode.lighten);
            } else if (c.name.contains('cloud') || c.name == 'building') {
              c.fills.first.paint.colorFilter =
                  ColorFilter.mode(Customization.variable_6, BlendMode.lighten);
            } else if (c.parent?.name == 'SLOGAN') {
              c.fills.first.paint.colorFilter =
                  ColorFilter.mode(Customization.variable_1, BlendMode.srcATop);
            } else if (c.parent?.name == 'TRAZADO-EDIFICIO') {
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

    _controller?.isActiveChanged.addListener(() {
      if (!_controller!.isActive) {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) => Navigator.pushReplacementNamed(
              context, notificationRoutePath ?? routePath),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}
