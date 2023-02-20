import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:iclavis/app/bloc_config.dart';
import 'package:path_provider/path_provider.dart';
import 'app/initial_config.dart';
import 'app/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await InitialConfig.init();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getTemporaryDirectory(),
  );
  runApp(DevicePreview(
      enabled: kDebugMode && kIsWeb,
      builder: (context) {
       return const BlocConfig(child: MyApp());
      }));
}
