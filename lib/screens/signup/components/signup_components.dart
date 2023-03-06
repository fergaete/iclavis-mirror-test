import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:iclavis/blocs/signup/signup_bloc.dart';
import 'package:iclavis/environment.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/routes/routes.dart';
import 'package:iclavis/widgets/widgets.dart';
import 'package:iclavis/shared/textstyles_shared.dart';
import 'package:iclavis/utils/validation/rut_validator.dart';


final _styles = TextStylesShared();

class SignUpComponents extends StatefulWidget {
  final bool hasException;
  final String exceptionMessage;

  const SignUpComponents({
    Key? key,
    required this.hasException,
    required this.exceptionMessage,
  }) : super(key: key);

  @override
  _SignUpComponentsState createState() => _SignUpComponentsState();
}

class _SignUpComponentsState extends State<SignUpComponents> {
  GlobalKey<FormBuilderState>? _signUpFormBuilderKey;

  final TextEditingController _userIdController = TextEditingController();

  bool isEnabled = false;
  bool showInfoText = true;
  String countryCode="CL";
  bool isValid = false;
  int textLength = 0;
  @override
  void initState() {
    _signUpFormBuilderKey = GlobalKey<FormBuilderState>();
    countryCode =  Environment.COUNTRY_CODE;
    WidgetsBinding.instance.addPostFrameCallback((_) => _userIdController.clear());
    if(countryCode=='CL') {
    _userIdController.addListener(() {
        RUTValidator.formatFromTextController(_userIdController);
    });
    }
    super.initState();
  }

  void onChangedApplyFormat(dynamic text) {
    textLength = text.length;
    if (countryCode == "PE") {
      if (text.length == 8) {
        setState(() {
          showInfoText = true;
          isEnabled = true;
        });
      } else if (!isValid) {
        setState(() {
          showInfoText = true;
          isEnabled = false;
        });
      }
    } else {
      if (text.length >= 8) {
        isValid = RUTValidator().validator(text) == null ? true : false;
        if (isValid) {
          setState(() {
            showInfoText = true;
            isEnabled = true;
          });
        } else {
          setState(() {
            showInfoText = false;
            isEnabled = false;
          });
        }
      } else if (!isValid) {
        setState(() {
          showInfoText = true;
          isEnabled = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    return FormWrap(
      width: 286.w,
      paddingSize: 56.h,
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
        Container(
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.only(
            bottom: 50.h,
          ),
          child: Text(
            i18n("signup.enter_id"),
            style: _styles.lightText(18.sp, Customization.variable_7),
          ),
        ),
        FormBuilder(
          key: _signUpFormBuilderKey,
          //readOnly: false,
          child: CustomTextField(
            key: const Key("userId"),
            attribute: "userId",
            controller: _userIdController,
            maxLength:  Environment.COUNTRY_CODE == "PE" ? 8 : 12,
            keyboardType: TextInputType.visiblePassword,
            title: i18n("signup.user_id"),
            titleStyle: _styles.mediumText(14.sp, Customization.variable_7),
            textStyle: _styles.regularText(14.sp, Customization.variable_7),
            icon: Icons.person_outline,
            iconBackgroundColor: const Color(0xff1A2341),
            margin: EdgeInsets.only(top: 3.5.h,),
            onChanged: onChangedApplyFormat,
          ),
        ),
        Visibility(
          visible: (widget.hasException ? false : showInfoText),
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              textLength<3?i18n("signup.id_format_exception"):'',
              style: _styles.lightText(12.sp, Customization.variable_7),
            ),
          ),
        ),
        InputInfo(
          visible: widget.hasException ? true : !showInfoText,
          label: widget.hasException
              ? i18n(widget.exceptionMessage)
              : i18n("signup.id_invalid_exception"),
          color: Customization.variable_5,
          margin: EdgeInsets.only(top: 2.h),
          link: ActionLink(
            link: '',
            onTap: () {},
            linkStyle: _styles.lightText(10.sp).copyWith(
                  decoration: TextDecoration.underline,
                ),
          ),
        ),
        Container(
          height: 36.h,
          margin: EdgeInsets.only(
            top: 22.h,
            bottom: 12.h,
          ),
          child: ActionButton(
              key: const Key("signup"),
              label: i18n("signup.enter_button"),
              isEnabled: isEnabled,
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (isEnabled) {
                  _signUpFormBuilderKey?.currentState?.save();
                  context.read<SignupBloc>().add(SignupButtonPressed(
                        dni: _signUpFormBuilderKey?.currentState?.value['userId'],
                      ));
                }
              }),
        ),
        ActionLink(
          question: i18n("signup.login_question"),
          link: i18n("signup.login"),
          questionStyle: _styles.regularText(14.sp, Customization.variable_7),
          linkStyle: _styles.mediumText(14.sp, Customization.variable_7),
          onTap: () => Navigator.pushNamed(context, RoutePaths.Login),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _userIdController.dispose();
    super.dispose();
  }

}