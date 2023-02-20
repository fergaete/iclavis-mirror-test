import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/services/user_storage/user_storage.dart';


import '../../personalizacion.dart';

class PostSaleDialog extends StatelessWidget {

  final String? title;
  final Widget? child;
  final double height;
  final _userStorage = UserStorage();

  PostSaleDialog({super.key, this.title,this.child,required this.height});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
        10.h,
      )),
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.only(left: 15.w,right: 5.w),
              decoration: BoxDecoration(
                  color: Customization.variable_2,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(10.h),
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title??'',
                    style: TextStyle(
                      color: Customization.variable_4,
                      fontSize: 14.sp,
                    ),
                  ),
                  IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Customization.variable_4,
                      ),
                      onPressed: (){
                        _userStorage.setReadAlert();
                        Navigator.pop(context);
                      }

                      )
                ],
              ),
            ),
            Container(
              child: child,
            )
          ],
        ),
      ),
    );
  }
}
