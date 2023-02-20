import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/route_paths.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';
import 'package:iclavis/utils/validation/field_validator.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'styles.dart';

final _styles = ForgotPasswordStyles();

class SetPassword extends StatelessWidget {
  const SetPassword({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Customization.variable_6,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Customization.variable_6,
          leading: GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Icon(
                CustomIcons.i_volver_atras,
                size: 16.sp,
                color: Customization.variable_7,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: BlocListener<SignupBloc, SignupState>(
          child: _View(),
          listener: (context, state) {
            if (state is ForgotPasswordSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutePaths.Login,
                (route) => true,
              );
            }else if (state is ConfirmForgotPasswordButtonSuccess) {
              Navigator.pushNamedAndRemoveUntil(
                context,
                RoutePaths.Login,
                    (route) => true,
              );
            }
            else if (state is ForgotPasswordFailure) {
              if (state.result.message!.contains('server')) {
                ModalOverlay(
                  context: context,
                  message: 'Parece que hay problemas con nuestro servidor.'
                      ' Aprovecha de despejar la mente e intenta más tarde.',
                  title: '¡Ups!',
                  buttonTitle: 'Entendido',
                  colorAllText: Colors.white,
                  backgroundColor: Color(0xff1A2341),
                );
              } else {
                ExceptionOverlay(
                  context: context,
                  message:state.result.message??''.i18n,
                );
              }
            }
          },
        ),
      ),
    );
  }
}

class _View extends StatefulWidget {
  const _View({Key? key}) : super(key: key);

  @override
  __ViewState createState() => __ViewState();
}

class __ViewState extends State<_View> {
  bool isValidPass = false;
  bool isValidRePass = false;
  bool formatError = false;
  String? password;
  String? rePassword;

  UserModel? user;

  @override
  void didChangeDependencies() {
    final userState = context.read<UserBloc>().state;

    if (userState is UserSuccess) {
      user = userState.user;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is ConfirmForgotPasswordButtonInProgress) {
            showWaitAnimation(context);
          } else {
            removeWaitAnimation();
          }
        },
        child: FormWrap(
          width: 286.w,
          paddingSize: 143.h,
          body: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(bottom: 23.h),
              child: Text(i18n('signup.Titulo_Cambio_Pass'),
                style: _styles.lightText(
                  18.sp,
                  Customization.variable_7,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                bottom: 23.h,
              ),
              alignment: Alignment.centerLeft,
              child: Text(
                i18n("signup.password_requirements"),
                style: _styles.lightText(14.sp, Customization.variable_7),
              ),
            ),
            CustomTextField(
              attribute: 'pass',
              title: i18n('signup.enter_new_password'),
              titleStyle: _styles.mediumText(14.sp, Customization.variable_7),
              textStyle: _styles.mediumText(14.sp, Customization.variable_7),
              margin: EdgeInsets.only(top: 10.h, bottom: 4.h),
              obscureText: true,
              onChanged: (v) {
                validatePassword(v);
                if (FieldValidator.password(v)) {
                  setState(() {
                    password = v;
                    isValidPass = true;
                  });
                } else {
                  setState(() {
                    isValidPass = false;
                  });
                }
              },
            ),
            InputInfo(
              visible: formatError,
              label:i18n('signup.password_alert'),
              styles: _styles.lightText(12.sp, Customization.variable_5),
              color: Customization.variable_5,
              margin: EdgeInsets.only(
                top: 0.h,
                bottom: 20.h,
              ),
            ),
            CustomTextField(
              attribute: 'repass',
              title: i18n('signup.confirm_new_password'),
              titleStyle: _styles.mediumText(14.sp, Customization.variable_7),
              textStyle: _styles.mediumText(14.sp, Customization.variable_7),
              margin: EdgeInsets.only(top: 10.h, bottom: 26.h),
              obscureText: true,
              onChanged: (v) {
                if (FieldValidator.password(v)) {
                  setState(() {
                    rePassword = v;
                    isValidRePass = true;
                  });
                } else {
                  setState(() {
                    isValidRePass = false;
                  });
                }
              },
            ),
            Container(
              height: 34.h,
              margin: EdgeInsets.only(bottom: 20.h),
              child: Theme(
                data: ThemeData(
                  disabledColor: const Color(0xff999595),
                ),
                child: ActionButton(
                  label: i18n('signup.save_button'),
                  labelStyle: _styles.mediumText(14.sp, Colors.white),
                  isEnabled: _isValidPasswords,
                  onPressed: () {
                    if (_isValidPasswords) {
                      FocusManager.instance.primaryFocus?.unfocus();

                      context.read<SignupBloc>().add(
                            ConfirmForgotPasswordButtonPressed(
                              email: user?.email??'',
                              confirmationCode: user?.code??'',
                              newPassword: password??'',
                            ),
                          );
                    }
                  },
                ),
              ),
            )
          ],
        ));
  }
  void validatePassword(String password) {
    if (password.length >= 5) {
      if (FieldValidator.password(password)) {
        setState(() {
          formatError = false;
        });
      } else {
        setState(() {
          formatError = true;
        });
      }
    }
  }

  bool get _isValidPasswords =>
      isValidPass & isValidRePass & (password == rePassword);
}
