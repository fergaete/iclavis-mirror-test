import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

class RegisterForm extends StatefulWidget {
  RegisterForm({Key? key}) : super(key: key);

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {

  final TextEditingController _controller= TextEditingController();
 int i =0;
  @override
  void dispose() {
   _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 286.w,
      color: Colors.red,
      child: TextFormField(
        controller: _controller,
        onChanged: onChangedApplyFormat,
      ),
    );
  }
  void onChangedApplyFormat(dynamic text) {
    formatFromTextController(_controller);
  }

  static void formatFromTextController(TextEditingController controller) {
    TextEditingValue newValue;

    newValue = const TextEditingValue(
      text: "x",);

    controller.value = TextEditingController.fromValue(newValue).value;

  }
}
