import 'package:flutter/material.dart';

import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'properties_slider.dart';
import 'property_image.dart';
import 'property_location.dart';
import 'release_date.dart';
import 'main_features.dart';
import 'project_features.dart';

import 'styles.dart';

final _styles = DrawerPropertyStyles();

class DrawerPropertyComponents extends StatelessWidget {
  DrawerPropertyComponents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 7.h),
        width: 340.w,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Card(
                elevation: 3.h,
                shadowColor: const Color(0xffdbdbdb),
                shape: _styles.propertyCardBorder,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:  const <Widget>[
                    PropertyImage(),
                    ReleaseDate(),
                    PropertyLocation(),
                  ],
                ),
              ),
              const PropertiesSlider(),
              const MainFeatures(),
              const ProjectFeatures(),
            ],
          ),
        ),
      ),
    );
  }
}
