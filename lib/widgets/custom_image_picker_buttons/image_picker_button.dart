import 'dart:io';


import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerButton extends StatefulWidget {
  final String attribute;

  const ImagePickerButton({super.key,
    required this.attribute,
  });

  @override
  _ImagePickerButtonState createState() => _ImagePickerButtonState();
}

class _ImagePickerButtonState extends State<ImagePickerButton> {
  late File pathFile;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            FocusScope.of(context).requestFocus(FocusNode());

            PickedFile? pickedFile = (await ImagePicker().pickImage(
              source: ImageSource.gallery,
            )) as PickedFile?;

            if (pickedFile != null) {
              setState(() {
                pathFile = File(pickedFile.path);
              });
            }
          },
          child: Container(
            /*child: FormBuilderCustomField(
              attribute: widget.attribute,
              formField: FormField(
                builder: (context) {
                  return pathFile != null
                      ? Image.file(
                          pathFile,
                          width: 64.w,
                          height: 54.h,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          alignment: Alignment.center,
                          width: 64.w,
                          height: 54.h,
                          color: Color(0xff9E9E9E).withOpacity(.20),
                          child: Icon(
                            Icons.add_circle,
                            size: 25.w,
                            color: Color(0xff9E9E9E).withOpacity(.59),
                          ),
                        );
                },
              ),
              valueTransformer: (v) {
                if (pathFile != null) {
                  return pathFile.path;
                } else {
                  return null;
                }
              },
            ),*/
          ),
        ),
      ],
    );
  }
}
