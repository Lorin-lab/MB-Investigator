import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:mb_investigator/data/repositories/remote_device_repository.dart';
import 'package:mb_investigator/domain/models/device_variable.dart';
import 'package:modbus_client/modbus_client.dart';

class VarWritingDialogueViewModel extends ChangeNotifier {
  VarWritingDialogueViewModel(
      {required RemoteDeviceRepository remoteDeviceRepo,
      required DeviceVariable deviceVariable})
      : _remoteDeviceRepo = remoteDeviceRepo,
        _deviceVariable = deviceVariable,
        _newValue = deviceVariable.getFormatedValue();

  final RemoteDeviceRepository _remoteDeviceRepo;
  final DeviceVariable _deviceVariable;

  String _newValue;
  String get newValue => _newValue;

  Uint8List? _finalEncodedData;
  Uint8List? get finalEncodedData => _finalEncodedData;

  String? _finalEncodedValue;
  String? get finalEncodedDValue => _finalEncodedValue;

  String? _encodingError;
  String? get encodingError => _encodingError;

  String _encodingErrorDetail = "";
  String get encodingErrorDetail => _encodingErrorDetail;

  void onNewValueEdit(String newValue) {
    _newValue = newValue;
    var dataRepresentation = _deviceVariable.settings.getDataRepresentation();
    try {
      var encodedValue = dataRepresentation.encodeValue(newValue,
          ModbusEndianness.ABCD, _deviceVariable.settings.dataUnitCount);

      _finalEncodedData = encodedValue;
      _finalEncodedValue = dataRepresentation.getFormatedValue(encodedValue,
          ModbusEndianness.ABCD, _deviceVariable.settings.dataUnitCount);
      _encodingError = null;
    } catch (e) {
      _finalEncodedData = null;
      _finalEncodedValue = null;
      _encodingError = "Invalide entry";
      _encodingErrorDetail = e.toString();
    }
    notifyListeners();
  }

  String get varName => _deviceVariable.settings.name;
  String get varEcoding => _deviceVariable.settings.dataEncoding.name;
  int get vardataUnitCount => _deviceVariable.settings.dataUnitCount;

  void cmdWrite(BuildContext context) {
    if (_finalEncodedData != null) {
      var device = _remoteDeviceRepo.getRemoteDevice();
      _deviceVariable.performWriting(device, _finalEncodedData!);
    }

    Navigator.pop(context);
  }
}
