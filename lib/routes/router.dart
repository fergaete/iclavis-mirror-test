import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:iclavis/app/my_app.dart';
import 'package:iclavis/blocs/project/project_bloc.dart';
import 'package:iclavis/models/project_model.dart';

import 'package:iclavis/routes/route_paths.dart';
import 'package:iclavis/screens/screens.dart';
import 'package:iclavis/services/user_identity/user_identity_repository.dart';

import '../blocs/authentication/authentication_bloc.dart';

mixin RouterMixin on State<MyApp> {
  final _router = GoRouter(
      initialLocation: '/',
      errorBuilder: (_,state)=>ErrorPage(goRouterState: state,),
      routes: [
    GoRoute(
        name: RouteName.SplashScreen,
        path: RoutePaths.SplashScreen,
        builder: (_, __) => SplashScreenPage()),
    GoRoute(
        name: RouteName.Login,
        path: RoutePaths.Login,
        builder: (_, __) => const LoginPage()),
    GoRoute(
        name: RouteName.PreHome,
        path: RoutePaths.PreHome,
        builder: (_, __) => PreHomePage(),

    ),
        GoRoute(
          name: RouteName.Onboarding,
          path: RoutePaths.Onboarding,
          builder: (_, __) => OnboardingPage(),

        ),
    GoRoute(
        name: RouteName.Home,
        path: RoutePaths.Home,
        builder: (_, __) => HomePage(),
        redirect: (context,state) async {

          bool hasSession = await UserIdentityRepository().checkAuth() ?? false;
          bool isProject=false;
          if(context.read<ProjectBloc>().state is ProjectSuccess){
            isProject = true;
            final List<ProjectModel> projects =
                (context.read<ProjectBloc>().state as ProjectSuccess).result.data;
            print(projects);
            var currentProject = projects.firstWhere((p) => p.isCurrent);
          }

          if(!hasSession)return RoutePaths.Login;
          if(hasSession && isProject){
            return null;
          }
          if(hasSession && !isProject){
            return RoutePaths.PreHome;
          }

          return RoutePaths.Login;
        }
    ),
  ]);

  GoRouter get router => _router;
}

class ErrorPage extends StatelessWidget{
   ErrorPage({super.key,required this.goRouterState});
  final GoRouterState goRouterState;
  @override
  Widget build(BuildContext context) {

     return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body:  Center(
        child: Text(goRouterState.error!.toString()),
      ),
    );;
  }

}
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePaths.SplashScreen:
        return SlideRightRoute(widget: SplashScreenPage(), settings: settings);

      case RoutePaths.Login:
        return SlideRightRoute(widget: LoginPage(), settings: settings);

      case RoutePaths.SignUp:
        return SlideRightRoute(widget: SignUpPage(), settings: settings);

      case RoutePaths.UserVerification:
        return SlideRightRoute(
            widget: UserVerificationPage(), settings: settings);

      case RoutePaths.SetPassword:
        return SlideRightRoute(widget: SetPasswordPage(), settings: settings);

      case RoutePaths.ForgoPassword:
        return SlideRightRoute(
            widget: ForgotPasswordPage(), settings: settings);

      case RoutePaths.Onboarding:
        return SlideRightRoute(widget: OnboardingPage(), settings: settings);

      case RoutePaths.PreHome:
        return SlideRightRoute(widget: PreHomePage(), settings: settings);

      case RoutePaths.Home:
        return SlideRightRoute(widget: HomePage(), settings: settings);

      case RoutePaths.Files:
        return SlideRightRoute(
            widget: HomePage(tabIndex: 1), settings: settings);

      case RoutePaths.FilesImage:
        return SlideRightRoute(
            widget: HomePage(
              tabIndex: 1,
              tabIndexUserFiles: 1,
            ),
            settings: settings);

      case RoutePaths.FilesVideo:
        return SlideRightRoute(
            widget: HomePage(
              tabIndex: 1,
              tabIndexUserFiles: 2,
            ),
            settings: settings);

      case RoutePaths.Payment:
        return SlideRightRoute(
            widget: HomePage(tabIndex: 2), settings: settings);

      case RoutePaths.Request:
        return SlideRightRoute(
            widget: HomePage(tabIndex: 3), settings: settings);

      case RoutePaths.RequestPvi:
        return SlideRightRoute(
            widget: HomePage(
              tabIndex: 3,
              tabIndexUserSupport: 2,
            ),
            settings: settings);

      case RoutePaths.Notification:
        return SlideRightRoute(
            widget: HomePage(tabIndex: 4), settings: settings);

      case RoutePaths.Properties:
        return SlideRightRoute(widget: DrawerProperty(), settings: settings);

      default:
        return errorRoute();
    }
  }

  static Route<dynamic> errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
        body: Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}

class SlideRightRoute extends PageRouteBuilder {
  final Widget widget;
  @override
  final RouteSettings settings;
  SlideRightRoute({required this.widget, required this.settings})
      : super(
          pageBuilder: (BuildContext context, Animation<double> animation,
              Animation<double> secondaryAnimation) {
            return widget;
          },
          settings: settings,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}
