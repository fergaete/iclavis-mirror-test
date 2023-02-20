import 'package:flutter/material.dart';
import 'package:iclavis/blocs/signup/signup_bloc.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:iclavis/personalizacion.dart';

import 'package:iclavis/screens/user_verification/components/custom_pin_code.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/utils/Translation/translation_extension.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'set_password.dart';
import 'styles.dart';

final _styles = ForgotPasswordStyles();

class InputCode extends StatefulWidget {
  const InputCode({Key? key}) : super(key: key);

  @override
  _InputCodeState createState() => _InputCodeState();
}

class _InputCodeState extends State<InputCode> {
  bool isValid = false;

  late UserModel user;

  late String code;

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
    return BlocListener<SignupBloc, SignupState>(
        listener: (context, state) {
          if (state is ForgotPasswordButtonSuccess) {
            removeWaitAnimation();
          } else if (state is ForgotPasswordButtonInProgress) {
            showWaitAnimation(context);
          } else if (state is SignupFailure) {
            removeWaitAnimation();
            ExceptionOverlay(context: context, message: 'Intentos excedidos');
          }
        },
        child: Padding(
          padding: EdgeInsets.only(left: 18.w),
          child: FormWrap(
            width: 304.w,
            paddingSize: 131.h,
            body: [
              Text(
                'signup.Titulo_Cambio_Pass_Codigo'.i18n,
                   // ??''+user?.email ?? 'sin email',
                style: _styles.lightText(16.sp, Customization.variable_7),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  width: 286.w,
                  margin: EdgeInsets.only(top: 50.h, bottom: 65.27.h),
                  child: CustomPinCode(
                    onChanged: (v) {
                      if (v.length == 6) {
                        setState(() {
                          code = v;
                          isValid = true;
                        });
                      } else if (v.length == 5) {
                        setState(() {
                          isValid = false;
                        });
                      }
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  width: 286.w,
                  height: 36.h,
                  child: Theme(
                    data: ThemeData(
                        disabledColor: Color(0xff999595), colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Color(0xff00A19A))),
                    child: ActionButton(
                        label:'signup.confirm_button'.i18n,
                        labelStyle:
                            _styles.mediumText(16.sp, Customization.variable_3),
                        isEnabled: isValid,
                        onPressed: () {
                          if (isValid) {
                            FocusManager.instance.primaryFocus?.unfocus();
                            context.read<UserBloc>().add(
                                  UserUpdated(
                                    user: user.copyWith(code: code),
                                  ),
                                );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BlocProvider.value(
                                  value: context.read<SignupBloc>(),
                                  child: SetPassword(),
                                ),
                              ),
                            );
                          }
                        }),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                child: InkWell(
                  child: Text('signup.Reenviar_Codigo'.i18n,
                      style:
                          _styles.mediumText(14.sp, Customization.variable_7)),
                  onTap: () => context.read<SignupBloc>().add(
                        ForgotPasswordButtonPressed(
                          email: user.email ??'',
                        ),
                      ),
                ),
              ),
            ],
          ),
        ));
  }
}
