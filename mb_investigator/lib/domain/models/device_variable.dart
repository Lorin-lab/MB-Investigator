import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:mb_investigator/domain/models/device_variable_settings.dart';
import 'package:mb_investigator/domain/models/modbus_raw_element.dart';
import 'package:mb_investigator/domain/models/remote_device.dart';
import 'package:modbus_client/modbus_client.dart';

/// Globallement un wraper pour ModbusElement en y intégrant les fonctionnalité propre à MB-investigator
class DeviceVariable {
  // Constructor
  DeviceVariable({required DeviceVariableSettings settings})
      : _settings = settings,
        _mbElement = _generateModbusElement(settings);

  // Settings
  final DeviceVariableSettings _settings;
  DeviceVariableSettings get settings =>
      DeviceVariableSettings.clone(_settings);
  final ModbusElement _mbElement;

  // Dynamique data
  ModbusResponseCode? lastResponseCode;
  dynamic lastReadValue;
  DateTime? lastReadTimestamp;

  ValueNotifier<DeviceVariableStatus> state =
      ValueNotifier<DeviceVariableStatus>(DeviceVariableStatus.idle);

  Future<ModbusResponseCode>? asyncWork;

  /// Perform a reading
  Future<ModbusResponseCode>? performReading(RemoteDevice remoteDevice) {
    if (asyncWork != null) {
      return asyncWork;
    }

    state.value = DeviceVariableStatus.reading;
    var readRequest = _mbElement.getReadRequest();
    //asyncWork = remoteDevice.getModbusClient().send(readRequest);
    asyncWork = () async {
      //await Future.delayed(const Duration(milliseconds: 10));
      return await remoteDevice.getModbusClient().send(readRequest);
    }();
    asyncWork!.then((value) {
      lastResponseCode = value;
    });
    asyncWork!.whenComplete(() {
      state.value = DeviceVariableStatus.idle;
      lastReadTimestamp = DateTime.now();
      asyncWork = null; // Reset
    });
    return asyncWork;
  }

  Future<ModbusResponseCode>? performWriting(
      RemoteDevice remoteDevice, Uint8List bytes) {
    if (asyncWork != null) {
      return asyncWork;
    }
    state.value = DeviceVariableStatus.writing;
    var writeRequest = _mbElement.getWriteRequest(bytes);
    asyncWork = () async {
      sleep(const Duration(microseconds: 1000));
      await Future.delayed(const Duration(milliseconds: 1000));
      return await remoteDevice.getModbusClient().send(writeRequest);
    }();
    asyncWork!.then((value) {
      lastResponseCode = value;
    });
    asyncWork!.whenComplete(() {
      state.value = DeviceVariableStatus.idle;
      lastReadTimestamp = DateTime.now();
      asyncWork = null; // Reset
    });
    return asyncWork;
  }

  String getFormatedValue() {
    if (_mbElement.value == null) {
      return "None";
    } else {
      try {
        return settings.getDataRepresentation().getFormatedValue(
            _mbElement.value, settings.endianness, settings.dataUnitCount);
      } catch (e) {
        return "Invalide data representation";
      }
    }
  }

  static ModbusElement _generateModbusElement(DeviceVariableSettings settings) {
    var bytecount = settings.dataUnitCount;
    if (settings.modbusElementType.isRegister) {
      bytecount *= 2; // word to byte
    }
    return ModbusRawElement(
        name: settings.name,
        type: settings.modbusElementType,
        address: settings.registerAddress,
        byteCount: bytecount);
  }
}

enum DeviceVariableStatus {
  idle,
  reading,
  writing,
}
