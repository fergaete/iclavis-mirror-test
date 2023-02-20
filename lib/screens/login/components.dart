import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:iclavis/blocs/login/login_bloc.dart';
import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/blocs/user/user_bloc.dart';
import 'package:iclavis/models/user_model.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/shared/custom_icons.dart';
import 'package:iclavis/utils/extensions/analytics.dart';
import 'package:iclavis/widgets/widgets.dart';

import 'styles.dart';

final _styles = LoginStyles();

class LoginComponents extends StatefulWidget {
  final bool hasException;
  final String exceptionMessage;

  const LoginComponents({
    Key? key,
    required this.hasException,
    required this.exceptionMessage,
  }) : super(key: key);

  @override
  _LoginComponentsState createState() => _LoginComponentsState();
}

class _LoginComponentsState extends State<LoginComponents> {
  final GlobalKey<FormBuilderState> formKey = GlobalKey<FormBuilderState>();

  FocusNode? usernameFocus;
  ScrollController? usernameScroll;

  String errorMessage = '';

  double errorPasswordHeight = 0;

  bool usernameTextValid = false;
  bool passwordTextValid = false;

  TextEditingController? tokenText;

  @override
  void initState() {
    tokenText = TextEditingController(text: '');
    usernameFocus = FocusNode();
    usernameScroll = ScrollController();

    usernameFocus?.addListener(() {
      if (usernameFocus!.hasFocus) {
        usernameScroll?.jumpTo(0);
      }
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    final loginBloc = BlocProvider.of<LoginBloc>(context);

    return FormWrap(
      width: 286.w,
      paddingSize: 100.h,
      body: [
        Customization.personalizable
            ? CachedNetworkImage(
                imageUrl: Customization.logo,
                fadeInDuration: const Duration(seconds: 0),
                height: 125.h,
              )
            : SvgPicture.asset(
                'assets/images/LOGO-iclavis.svg',
                height: 125.h,
              ),
        SizedBox(
          height: 80.h,
        ),
        FormBuilder(
          key: formKey,
          child: Column(
            children: <Widget>[
              CustomTextField(
                key: const Key("username"),
                attribute: "username",
                controller: tokenText,
                scrollController: usernameScroll,
                margin: EdgeInsets.only(
                  bottom: widget.hasException == true ? 4.h : 10.5.h,
                ),
                hintText: FlutterI18n.translate(context, "login.username_hint"),
                textStyle: _styles.regularText(14.sp, const Color(0xffE9E4DC)),
                icon: CustomIcons.i_email,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(
                      errorText: i18n("login.login_fail_mail")),
                  FormBuilderValidators.email(),
                ]),
                onChanged: (v) {
                  if (v.length > 5) {
                    setState(() {
                      usernameTextValid = true;
                    });
                  } else {
                    setState(() {
                      usernameTextValid = false;
                    });
                  }
                },
              ),
              InputInfo(
                visible: widget.hasException,
                label: widget.exceptionMessage,
                color: Customization.variable_5,
                margin: EdgeInsets.only(
                  bottom: 15.5.h,
                ),
              ),
              CustomTextField(
                key: const Key("password"),
                attribute: "password",
                focusNode: usernameFocus,
                hintText: i18n("login.password_hint"),
                textStyle: _styles.regularText(14.sp, const Color(0xffE9E4DC)),
                icon: CustomIcons.i_contrasen_a,
                iconBackgroundColor: const Color(0xff1A2341),
                obscureText: true,
                margin: EdgeInsets.only(
                  bottom: 0.h,
                ),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.minLength(7)
                ]),
                onChanged: (v) {
                  if (v.length > 7) {
                    setState(() {
                      passwordTextValid = true;
                    });
                  } else {
                    setState(() {
                      passwordTextValid = false;
                    });
                  }
                },
              ),
            ],
          ),
        ),
        Container(
          width: 286.w,
          margin: EdgeInsets.only(
            top: 3.5.h,
            bottom: 30.h,
          ),
          alignment: Alignment.centerRight,
          child: InkWell(
            child: Text(
              i18n("login.forgot_password"),
              style: _styles.italicOpenSansText(
                Customization.variable_7,
              ),
            ),
            onTap: () {
              FocusManager.instance.primaryFocus?.unfocus();
              if (usernameTextValid) {
                formKey.currentState?.save();
                context.read<UserBloc>().add(
                      UserUpdated(
                        user: UserModel(
                          email: formKey.currentState?.value['username'],
                        ),
                      ),
                    );
                Analytics().addEvent(name: 'olvidar_contraseña');
                context.read<SignupBloc>().add(
                      ForgotPasswordButtonPressed(
                        email: formKey.currentState?.value['username'],
                      ),
                    );
              } else {
                ExceptionOverlay(
                  context: context,
                  message: i18n("login.login_fail_mail"),
                );
              }
            },
          ),
        ),
        Container(
          height: 36.h,
          margin: EdgeInsets.only(
            bottom: 12.h,
          ),
          child: ActionButton(
            key: const Key("login"),
            label: i18n("login.login"),
            isEnabled: (passwordTextValid && usernameTextValid),
            onPressed: () {
              FocusScope.of(context).requestFocus(FocusNode());
              if (formKey.currentState!.saveAndValidate() &&
                  passwordTextValid&&usernameTextValid) {
                loginBloc.add(
                  LoginButtonPressed(
                    email: formKey.currentState?.value['username'],
                    password: formKey.currentState?.value['password'],
                  ),
                );
              }
            },
          ),
        ),
        ActionLink(
          question: i18n("login.question_label"),
          link: i18n("login.sign_up"),
          questionStyle: _styles.regularText(14.sp, Customization.variable_7),
          linkStyle: _styles.mediumText(14.sp, Customization.variable_7),
          onTap: () => Navigator.pushNamed(context, RoutePaths.SignUp),
        ),
      ],
    );
  }
}
