import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:async/async.dart';
import 'package:file_picker/file_picker.dart';

import 'package:flutter/material.dart';
import 'package:mb_investigator/data/repositories/device_variables_repository.dart';
import 'package:mb_investigator/data/repositories/remote_device_repository.dart';
import 'package:mb_investigator/domain/models/device_variable_settings.dart';
import 'package:mb_investigator/domain/models/remote_device.dart';
import 'package:mb_investigator/domain/models/remote_device_settings.dart';
import 'package:mb_investigator/domain/models/device_variable.dart';
import 'package:mb_investigator/domain/use_cases/import_export_config.dart';
import 'package:mb_investigator/ui/var_writing_dialogue/var_writing_dialogque_viewmodel.dart';
import 'package:mb_investigator/ui/var_writing_dialogue/var_writing_dialogue_screen.dart';

class DeviceVariableListingViewModel extends ChangeNotifier {
  DeviceVariableListingViewModel({
    required RemoteDeviceRepository remoteDeviceRepository,
    required DeviceVariableRepository deviceVariableRepository,
    required ImportExportConfig importExportConfig,
  })  : _remoteDeviceRepository = remoteDeviceRepository,
        _deviceVariableRepository = deviceVariableRepository,
        _importExportConfig = importExportConfig;

  final RemoteDeviceRepository _remoteDeviceRepository;
  final DeviceVariableRepository _deviceVariableRepository;
  final ImportExportConfig _importExportConfig;

  void changeClient(RemoteDeviceSettings modifiedSettings) {
    _remoteDeviceRepository.changeRemoteDeviceSettings(modifiedSettings);
    notifyListeners();
  }

  void setDeviceVariableSettings(
      DeviceVariable? deviceVariable, DeviceVariableSettings settings) {
    if (deviceVariable == null) {
      _deviceVariableRepository.addDeviceVariable(settings);
    } else {
      _deviceVariableRepository.replaceDeviceVariable(deviceVariable, settings);
    }
    notifyListeners();
  }

  void removeDeviceVariable(DeviceVariable deviceVariable) {
    _deviceVariableRepository.removeDeviceVariable(deviceVariable);
    notifyListeners();
  }

  void reorderDeviceVariableList(int oldIndex, int newIndex) =>
      _deviceVariableRepository.reorderDeviceVariableList(oldIndex, newIndex);

  String getClientName() {
    var settings = _remoteDeviceRepository.getRemoteDevice().settings;
    if (settings.type == RemoteDeviceType.tcp ||
        settings.type == RemoteDeviceType.udp) {
      return "${settings.deviceName} (${settings.serverAdress})";
    } else {
      return "${settings.deviceName} (${settings.serialPortName})";
    }
  }

  RemoteDeviceSettings getRemoteDeviceSettings() {
    return _remoteDeviceRepository.getRemoteDevice().settings;
  }

  List<DeviceVariable> getDeviceVariables() {
    return _deviceVariableRepository.getDeviceVariables();
  }

  //////[Modbus_controle]//////////////////////////
  bool reapeatReading = false;
  CancelableOperation? readingFuture;
  int readingPeriode = 1000; // [ms]

  bool isAbleToReading() {
    return readingFuture != null && !(readingFuture!.isCompleted);
  }

  bool isAbleToStop() {
    return readingFuture != null &&
        !(readingFuture!.isCanceled || readingFuture!.isCompleted);
  }

  void startReading() {
    readingFuture =
        CancelableOperation.fromFuture(_reader(), onCancel: notifyListeners);
    readingFuture!.then(
      (value) => _onReadingEnd(),
      onCancel: () => _onReadingEnd(),
      onError: (obj, stack) => _onReadingEnd(),
    );
    notifyListeners();
  }

  void stopReading() {
    readingFuture?.cancel();
    notifyListeners();
  }

  void _onReadingEnd() {
    readingFuture = null;
    notifyListeners();
  }

  Future _reader() async {
    do {
      var remoteDevice = _remoteDeviceRepository.getRemoteDevice();
      var deviceVariables = _deviceVariableRepository.getDeviceVariables();

      await _readDeviceVariables(remoteDevice, deviceVariables);
      await Future.delayed(Duration(milliseconds: readingPeriode));
    } while (reapeatReading && !(readingFuture?.isCanceled ?? true));
  }

  Future _readDeviceVariables(
      RemoteDevice remoteDevice, List<DeviceVariable> deviceVariable) async {
    for (var v in deviceVariable.toList()) {
      await _readDeviceVariable(remoteDevice, v);
      if (readingFuture?.isCanceled ?? true) {
        break;
      }
    }
  }

  Future _readDeviceVariable(
      RemoteDevice remoteDevice, DeviceVariable deviceVariable) async {
    var test = deviceVariable.performReading(remoteDevice);
    await test;
  }

  //////[import_and_export]//////////////////////////
  Future importConfig() async {
    var result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: "Import configuration");

    if (result != null) {
      var file = result.files.first.xFile;
      var string = await file.readAsString();
      var json = jsonDecode(string);
      _importExportConfig.importConfiguration(json);
    }
    notifyListeners();
  }

  Future expotrConfig() async {
    var outputFile = await FilePicker.platform.saveFile(
      dialogTitle: "Export configuration",
      fileName:
          '${_remoteDeviceRepository.getRemoteDevice().settings.deviceName}.json',
      type: FileType.custom,
      allowedExtensions: ['json'],
    );
    if (outputFile != null) {
      var json = _importExportConfig.exportConfigurationPrettyString();
      await File(outputFile).writeAsString(json);
    }
  }

  void writeVar(BuildContext context, DeviceVariable deviceVariable) {
    VarWritingDialogueScreen.show(
        context,
        VarWritingDialogueViewModel(
            remoteDeviceRepo: _remoteDeviceRepository,
            deviceVariable: deviceVariable));
  }
}
