import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:iclavis/models/user_support_history_request_model.dart';
import 'package:iclavis/screens/home/components/tabbar_views/user_support_views/styles.dart';
import 'package:iclavis/widgets/postsale_dialog/widget.dart';

final _styles = UserSupportViewsStyles();

class RequirementsCardDialog {
  void openPostSaleDialogImage(
      BuildContext globalContext, String folio, List<Documento> documentos) {
    FocusScope.of(globalContext).requestFocus(FocusNode());
    List<Documento> images = [];
    documentos.forEach((e) {
      if (RegExp(r"(png|jpg|jpeg|gif|BMP)$").stringMatch(e.url!) != null) {
        images.add(e);
      }
    });
    showDialog(
      context: globalContext,
      builder: (BuildContext context) => PostSaleDialog(
          height: 400,
          title: "Imagenes",
          child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0),
              shrinkWrap: true,
              itemCount: images.length,
              itemBuilder: (context, i) => CachedNetworkImage(
                    imageUrl:images[i].url!,
                    placeholder: (_, url) =>
                        const Center(child: CircularProgressIndicator()),
                    imageBuilder: (_, image) {
                      return GestureDetector(
                        onTap: null,
                        child: Container(
                          width: 160.w,
                          height: 56.h,
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.grey.withOpacity(0.1),
                            image: DecorationImage(
                              image: image,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      );
                    },
                    errorWidget: (_, url, __) {
                      return Container();
                    },
                  ))),
    );
  }

  void openPostSaleDialogFile(
      BuildContext globalContext, String folio, List<Documento> documentos) {
    FocusScope.of(globalContext).requestFocus(FocusNode());
    List<Documento> files = [];
    documentos.forEach((e) {
      if (RegExp(r"(pdf|doc|xls|prf)$").stringMatch(e.url!) != null) {
        files.add(e);
      }
    });
    showDialog(
      context: globalContext,
      builder: (BuildContext context) => PostSaleDialog(
          height: 400,
          title: "Documentos",
          child: SizedBox(
            height: 350,
            child: ListView.builder(
                itemCount: files.length,
                itemBuilder: (context, i) => ListTile(
                      leading: Icon(
                        Icons.insert_drive_file,
                        size: 28.w,
                      ),
                      title: Text(
                        files[i].nombre??'',
                        style: _styles.lightText(14.sp, Color(0xff121212)),
                      ),
                      trailing: GestureDetector(
                        child: Container(
                          width: 24.w,
                          height: 24.w,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: const Color(0xffe0e0e0).withOpacity(.7),
                                  offset: Offset(0, 5.h),
                                  blurRadius: 6)
                            ],
                          ),
                          child: Icon(
                            Icons.open_in_new,
                            size: 13.w,
                          ),
                        ),
                        onTap: () async {
                          launchUrl(Uri.parse( files[i].url!));
                        },
                      ),
                    )),
          )),
    );
  }
}
