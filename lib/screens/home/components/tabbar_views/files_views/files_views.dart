import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:iclavis/blocs/image/image_bloc.dart';
import 'package:iclavis/blocs/video/video_bloc.dart';
import 'package:iclavis/blocs/document/document_bloc.dart';
import 'package:iclavis/shared/shared.dart';
import 'package:iclavis/utils/extensions/analytics.dart';

import 'doc_body.dart';
import 'image_body.dart';
import 'video_body.dart';

class FilesViews extends StatefulWidget {
  final int? tabIndex;
  const FilesViews({super.key,this.tabIndex});

  @override
  _FilesViewsState createState() => _FilesViewsState();
}

class _FilesViewsState extends State<FilesViews>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  int i = 0;

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this,initialIndex: widget.tabIndex??0);
    i=widget.tabIndex??0;
    _tabController.addListener(_handleTabSelection);
    super.initState();
  }

  _handleTabSelection() {
    if (_tabController.indexIsChanging) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    String i18n(String text) => FlutterI18n.translate(context,text);
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          labelColor: const Color(0xff2F2F2F),
          indicatorColor: Colors.transparent,
          onTap: (indicator) => setState(() {
            i = indicator;
            tabAnalytics(i);
          }),
          tabs: [
            CustomHeaderTab(
              icon: CustomIcons.i_documentos,
              text: i18n("archive.tag_documents"),
              isActive: i == 0 ? true : false,
            ),
            CustomHeaderTab(
              icon: CustomIcons.i_imagenes,
              iconSize: 18.w,
              text: i18n("archive.tag_photos"),
              isActive: i == 1 ? true : false,
            ),
            CustomHeaderTab(
              icon: CustomIcons.i_videos,
              iconSize: 20.5.w,
              text: i18n("archive.tag_videos"),
              isActive: i == 2 ? true : false,
            ),
          ],
        ),
        Expanded(
          child: FilesBody(
            controller: _tabController,
          ),
        ),
      ],
    );
  }
  void tabAnalytics(int i) {
    Analytics().addEventUserProject(name: i==0?'tab_documentos':
    i==1?'tab_fotos':i==2?'tab_videos':'', context: context);
  }

}

class CustomHeaderTab extends StatelessWidget {
  final IconData icon;
  final double? iconSize;
  final String text;
  final bool isActive;

  const CustomHeaderTab({
    Key? key,
    required this.icon,
    this.iconSize,
    required this.text,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 68.h,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 42.w,
            height: 42.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isActive ? const Color(0xffC2C2C2) : const Color(0xffF6F6F6),
            ),
            child: Icon(
              icon,
              size: iconSize ?? 29.w,
            ),
          ),
          Text(text,
            maxLines: 1,
            textScaleFactor: 1.0,),
        ],
      ),
    );
  }
}

class FilesBody extends StatelessWidget {
  final TabController controller;

  const FilesBody({Key? key, required this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => DocumentBloc()),
        BlocProvider(create: (_) => ImageBloc()),
        BlocProvider(create: (_) => VideoBloc()),
      ],
      child: Padding(
        padding: EdgeInsets.only(
          top: 46.h,
        ),
        child: TabBarView(
          controller: controller,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            const DocBody(),
            ImageBody(),
            VideosBody(),
          ],
        ),
      ),
    );
  }
}
