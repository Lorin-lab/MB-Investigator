import 'package:flutter/material.dart';
import 'package:mb_investigator/data/repositories/device_variables_repository.dart';
import 'package:mb_investigator/data/repositories/remote_device_repository.dart';
import 'package:mb_investigator/domain/use_cases/import_export_config.dart';
import 'package:mb_investigator/ui/device_variable_listing/device_variable_listing_screen.dart';
import 'package:mb_investigator/ui/device_variable_listing/device_variable_listing_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (context) => DeviceVariableRepository()),
        Provider(create: (context) => RemoteDeviceRepository()),
        Provider(
            create: (context) => ImportExportConfig(
                deviceVariableRepository: context.read(),
                remoteDeviceRepository: context.read())),
        ListenableProvider(
            create: (context) => DeviceVariableListingViewModel(
                deviceVariableRepository: context.read(),
                remoteDeviceRepository: context.read(),
                importExportConfig: context.read())),
      ],
      child: MaterialApp(
        title: 'MB-Investigator',
        theme: ThemeData(
            useMaterial3: true,
            colorScheme: ColorScheme.fromSwatch(
              primarySwatch: Colors.orange,
              backgroundColor: const Color(0xff454445),
              cardColor: const Color.fromARGB(255, 112, 112, 112),
              accentColor: const Color(0xff00c85e),
              errorColor: const Color.fromARGB(255, 138, 3, 3),
              brightness: Brightness.dark,
            ),
            scaffoldBackgroundColor: const Color(0xff353435),
            appBarTheme: const AppBarTheme(backgroundColor: Color(0xff454445))),
        themeMode: ThemeMode.dark,
        home: const DeviceVariableListingScreen(),
      ),
    );
  }
}
