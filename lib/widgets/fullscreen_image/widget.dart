import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:iclavis/personalizacion.dart';
import 'package:iclavis/services/files/files_repository.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iclavis/utils/extensions/download.dart';

final _styles = TextStylesShared();

class FullScreenImage extends StatelessWidget {
  final String imgUrl;
  final String? title;
  final bool option;

  FullScreenImage({super.key, required this.imgUrl, this.title, this.option = false});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            child: Padding(
              padding: EdgeInsets.only(left: 10.w),
              child: Icon(
                CustomIcons.i_volver_atras,
                size: 15.5.w,
                color: Customization.variable_2,
              ),
            ),
            onTap: () => Navigator.pop(context),
          ),
          title: Text(
            title ?? "Fotos",
            style: _styles.lightText(18.sp, Color(0xff121212)),
          ),
          centerTitle: true,
          actions: option?<Widget>[
            PopupMenuButton<String>(
              onSelected: handleClick,
              icon: Icon(
                Icons.more_vert,
                color: Customization.variable_2,
              ),
              itemBuilder: (BuildContext context) {
                return {'Descargar'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ]:null,
        ),
        body: Container(
            child: InteractiveViewer(
              panEnabled: true,
              minScale: 0.2,
              maxScale: 6,
              child: CachedNetworkImage(
                imageUrl: imgUrl,
                imageBuilder: (_, image) {
                  return Container(
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.grey.withOpacity(0.1),
                      image: DecorationImage(
                        image: image,
                        fit: BoxFit.contain,
                      ),
                    ),
                  );
                },
                errorWidget: (_, url, __) {
                  return Container();
                },
              ),
            )));
  }
  void handleClick(String value)  {

    if(value=='Descargar'){
      DownloadUtil().download(imgUrl, imgUrl);
    }
  }

  DownloadFile() async {
    final FilesRepository _filesRepository = FilesRepository();
   _filesRepository.downloadDocument(
      documentUrl: imgUrl,
      documentName: imgUrl,
    ).then((value) => null);
  }
}


