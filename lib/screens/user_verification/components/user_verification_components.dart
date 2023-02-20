import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/user/user.dart';
import 'package:iclavis/blocs/user_verification/user_verification_bloc.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'custom_pin_code.dart';

import 'styles.dart';

final _styles = UserVerificationStyles();

class UserVerificationComponents extends StatefulWidget {
  const UserVerificationComponents({Key? key}) : super(key: key);

  @override
  _UserVerificationComponentsState createState() =>
      _UserVerificationComponentsState();
}

class _UserVerificationComponentsState
    extends State<UserVerificationComponents> {
  bool confirmResult = true;

  bool isEnabled = false;

  String pin = '';
  String email = '';

  @override
  void didChangeDependencies() {
    final userState = context.read<UserBloc>().state;

    if (userState is UserSuccess) {
      email = userState.user.email!;
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    final state = context.watch<UserVerificationBloc>().state;

    if (state is UserVerificationFailure) {
      confirmResult = state.result.data;
    }

    return BlocListener<UserVerificationBloc, UserVerificationState>(
        listener: (context, state) {
          if (state is UserVerificationInProgress) {
            showWaitAnimation(context);
          } else {
            removeWaitAnimation();
          }
        },
        child: FormWrap(
          width: 286.w,
          paddingSize: 111.h,
          body: [
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 231.w,
                padding: EdgeInsets.only(
                  bottom: 80.h,
                ),
                child: Text(
                  "${i18n("signup.Texto_Codigo_Validacion")} $email",
                  style: _styles.lightText(16.sp, Customization.variable_7),
                ),
              ),
            ),
            CustomPinCode(
              key: Key("pincode"),
              onChanged: (v) {
                if (v.length == 6) {
                  setState(() {
                    isEnabled = true;
                    pin = v;
                  });
                } else if (v.length == 5) {
                  setState(() => isEnabled = false);
                }
              },
            ),
            Visibility(
              visible: !confirmResult,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: InputInfo(
                      label: i18n("signup.Excepcion_codigo_incorrecto"),
                      color: Customization.variable_5,
                    ),
                  ),
                  Visibility(
                    visible: false,
                    child: Text(
                      "¿Necesitas ayuda?",
                      style: _styles.errorInfoText,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 36.h,
              margin: EdgeInsets.only(
                top: 65.27.h,
                bottom: 10.h,
              ),
              child: ActionButton(
                key: Key("verify_user"),
                label: i18n("signup.confirm_button"),
                isEnabled: isEnabled,
                onPressed: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                  if (isEnabled) {
                    context
                        .read<UserVerificationBloc>()
                        .add(ConfirmButtonPressed(
                          pin: pin,
                        ));
                  }
                },
              ),
            ),
            ActionLink(
              link: i18n("signup.Reenviar_Codigo"),
              linkStyle: _styles.regularText(14.sp, Customization.variable_7),
              onTap: () => context.read<UserVerificationBloc>().add(
                    ResendCodeButtonPressed(email: email),
                  ),
            ),
          ],
        ));
  }

  void helpFormBottomSheet() {
    showBottomSheet(
      context: context,
      builder: (_) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: 577.h,
            ),
            decoration: BoxDecoration(
              border: _styles.border,
              borderRadius: _styles.slidingBorderRadius,
            ),
            child: HelpForm(),
          ),
        );
      },
    );
  }
}
