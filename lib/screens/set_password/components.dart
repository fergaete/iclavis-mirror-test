import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/utils/utils.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/widgets/widgets.dart';

final _styles = TextStylesShared();

class SetPasswordComponents extends StatefulWidget {
  const SetPasswordComponents({Key? key}) : super(key: key);

  @override
  _SetPasswordComponentsState createState() => _SetPasswordComponentsState();
}

class _SetPasswordComponentsState extends State<SetPasswordComponents> {
  final GlobalKey<FormBuilderState> _setPasswordFormBuilderKey =
      GlobalKey<FormBuilderState>();

  final TextEditingController passwordController =
      TextEditingController(text: '');

  bool isEnabled = false;
  bool hasInputError = false;
  bool formatError = false;
  bool isFormatValid = false;

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is SignupInProgress) {
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
              child: Text(
                i18n("signup.set_password_title"),
                style: _styles.lightText(18.sp, Customization.variable_7),
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
            FormBuilder(
              key: _setPasswordFormBuilderKey,
              //readOnly: false,
              child: Column(
                children: [
                  CustomTextField(
                    key: Key("password"),
                    attribute: "password",
                    controller: passwordController,
                    title: i18n("signup.enter_new_password"),
                    titleStyle:
                        _styles.mediumText(14.sp, Customization.variable_7),
                    textStyle:
                        _styles.regularText(14.sp, Customization.variable_7),
                    margin: EdgeInsets.only(
                      top: 5.h,
                      bottom: 10.h,
                    ),
                    obscureText: true,
                    onChanged: (v) {
                      validatePassword();
                      if (v.length > 5) {
                        setState(() {
                          isFormatValid = true;
                        });
                      } else {
                        setState(() {
                          isFormatValid = false;
                        });
                      }

                    },
                  ),
                  InputInfo(
                    visible: formatError,
                    label: i18n("signup.password_alert"),
                    styles: _styles.lightText(12.sp, Customization.variable_5),
                    color: Customization.variable_5,
                    margin: EdgeInsets.only(
                      top: 5.h,
                      bottom: 15.h,
                    ),
                  ),
                  CustomTextField(
                    key: Key("confirmPassword"),
                    attribute: "confirmPassword",
                    title: i18n("signup.confirm_new_password"),
                    titleStyle:
                        _styles.mediumText(14.sp, Customization.variable_7),
                    textStyle:
                        _styles.regularText(14.sp, Customization.variable_7),
                    margin: EdgeInsets.only(
                      bottom: 4.h,
                    ),
                    obscureText: true,
                    onChanged: (v) {
                      validatePassword();
                    },
                  ),
                  InputInfo(
                    visible: hasInputError,
                    label: isFormatValid == false
                        ? i18n("signup.password_alert")
                        : i18n("signup.password_match_exception"),
                    styles: _styles.lightText(12.sp, Customization.variable_5),
                    color: Customization.variable_5,
                  ),
                ],
              ),
            ),
            Container(
              height: 36.h,
              margin: EdgeInsets.only(top: hasInputError ? 40.h : 25.h),
              child: ActionButton(
                key: Key("set_password"),
                label: i18n("signup.register_button"),
                isEnabled: isEnabled,
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());

                  if (isEnabled) {
                    context.read<SignupBloc>().add(
                          ChangePasswordButtonPressed(
                            newPassword: _setPasswordFormBuilderKey
                                .currentState?.value["password"],
                          ),
                        );
                  }
                },
              ),
            ),
          ],
        ));
  }

  void validatePassword() {
    _setPasswordFormBuilderKey.currentState?.save();
    final String password =
        _setPasswordFormBuilderKey.currentState?.value["password"];

    final String confirmPassword =
        _setPasswordFormBuilderKey.currentState?.value["confirmPassword"];


    if(isFormatValid){
      if(FieldValidator.password(password)){
        setState(() {
          formatError = false;
        });
      }else{
        setState(() {
          formatError = true;
        });
      }
    }else{
      setState(() {
        formatError = false;
      });
    }

    if ([password, confirmPassword].every((e) => FieldValidator.password(e))) {
      if (password == confirmPassword) {
        setState(() {
          isEnabled = true;
          hasInputError = false;
        });
      } else {
        setState(() {
          isEnabled = false;
          hasInputError = true;
        });
      }
    } else {
      setState(() {
        isEnabled = false;
      });
    }
  }

  void openHelpForm() {
    FocusScope.of(context).requestFocus(FocusNode());
    showDialog(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        height: 96.h,
        width: 168.w,
        icon: GestureDetector(
          child: Icon(
            CustomIcons.i_ayuda,
            color: Colors.white,
            size: 29.w,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        description: '¿Necesitas Ayuda?',
        onPressed: () => Navigator.pop(context),
      ),
    );
  }
}
