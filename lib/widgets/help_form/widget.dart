import 'package:flutter/material.dart';

import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'styles.dart';

import '../widgets.dart';

final _styles = HelpFormStyles();

class HelpForm extends StatefulWidget {
  HelpForm({Key? key}) : super(key: key);

  @override
  _HelpFormState createState() => _HelpFormState();
}

class _HelpFormState extends State<HelpForm> {
  final GlobalKey<FormBuilderState> _helpFormBuilderKey =
      GlobalKey<FormBuilderState>();

  bool nameValid = false;
  bool lastnameValid = false;
  bool emailValid = false;
  bool buildingValid = false;
  bool problemValid = false;

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context, text);

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  width: 286.w,
                  margin: EdgeInsets.only(
                    top: 23.h,
                    bottom: 8.5.h,
                  ),
                  child: Text(
                    i18n("help_form.slidingPanel.helpLabel"),
                    style: _styles.mediumText(16.sp, Color(0xff463E40)),
                  ),
                ),
                Divider(
                  height: 1.h,
                  color: Color(0xff999595),
                ),
                Container(
                  width: 286.w,
                  padding: EdgeInsets.only(
                    top: 8.5.h,
                  ),
                  child: FormBuilder(
                    key: _helpFormBuilderKey,
                    //readOnly: false,//TODO:revisar este parametro
                    child: Column(
                      children: <Widget>[
                        CustomTextField(
                          attribute: "name",
                          title: i18n("help_form.slidingPanel.name"),
                          icon: Icons.person,
                       /*   onChanged: (v) {
                            if (v.isNotEmpty) {
                              setState(() => nameValid = true);
                            } else {
                              setState(() => nameValid = false);
                            }
                          },*/
                        ),
                        CustomTextField(
                          attribute: "lastname",
                          title: i18n("help_form.slidingPanel.lastname"),
                          icon: Icons.person,
                       /*   onChanged: (v) {
                            if (v.isNotEmpty) {
                              setState(() => lastnameValid = true);
                            } else {
                              setState(() => lastnameValid = false);
                            }
                          },*/
                        ),
                        CustomTextField(
                          attribute: "email",
                          title: i18n("help_form.slidingPanel.email"),
                          icon: Icons.email,
                         /* onChanged: (v) {
                            if (v.isNotEmpty) {
                              setState(() => emailValid = true);
                            } else {
                              setState(() => emailValid = false);
                            }
                          },*/
                        ),
                        CustomDropdown(
                          attribute: "building",
                          label: i18n("help_form.slidingPanel.building"),
                          data: [
                            'Condominio 1',
                            'Condominio 2',
                            'Condominio 3'
                          ],
                          onChanged: (v) {
                            if (v.isNotEmpty) {
                              setState(() => buildingValid = true);
                            } else {
                              setState(() => buildingValid = false);
                            }
                          },
                        ),
                        CustomTextField(
                          attribute: "problem",
                          expands: true,
                          title: i18n("help_form.slidingPanel.problem"),
                          height: 69.h,
                          decoration: _styles.textAreaFieldDecoration.copyWith(
                            contentPadding: EdgeInsets.only(
                              top: 10.h,
                              left: 10.w,
                            ),
                          ),
                       /*   onChanged: (v) {
                            if (v.isNotEmpty) {
                              setState(() => problemValid = true);
                            } else {
                              setState(() => problemValid = false);
                            }
                          },*/
                        ),
                        CustomImagePickerButtons(
                          label: i18n("help_form.slidingPanel.screenshot"),
                          maxSizeLabel: "Max. 25 Mb",
                          buttons: ['image1', 'image2', 'image3', 'image4'],
                        ),
                        Container(
                          width: 113.4.w,
                          height: 33.73.h,
                          margin: EdgeInsets.only(
                            bottom: 11.27.h,
                          ),
                          decoration: _styles.buttonBoxDecoration,
                          child: ActionButton(
                            label: i18n("help_form.button.label"),
                            isEnabled: _formFieldsVerification,
                            onPressed: () {
                              //if(formFieldsVerification()){}
                              //_helpFormBuilderKey.currentState.save();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  bool get _formFieldsVerification =>
      nameValid && lastnameValid && emailValid && buildingValid && problemValid;
}
