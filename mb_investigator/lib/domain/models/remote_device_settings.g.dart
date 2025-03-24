// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_device_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RemoteDeviceSettings _$RemoteDeviceSettingsFromJson(
        Map<String, dynamic> json) =>
    RemoteDeviceSettings()
      ..deviceName = json['deviceName'] as String
      ..type = $enumDecode(_$RemoteDeviceTypeEnumMap, json['type'])
      ..globalUnitId = (json['globalUnitId'] as num).toInt()
      ..responseTimeout = (json['responseTimeout'] as num).toInt()
      ..serverAdress = json['serverAdress'] as String
      ..port = (json['port'] as num).toInt()
      ..connectionTimeout = (json['connectionTimeout'] as num).toInt()
      ..delayAfterConnect = (json['delayAfterConnect'] as num).toInt()
      ..serialPortName = json['serialPortName'] as String
      ..serialBaudRate =
          $enumDecode(_$SerialBaudRateEnumMap, json['serialBaudRate'])
      ..serialDataBits =
          $enumDecode(_$SerialDataBitsEnumMap, json['serialDataBits'])
      ..serialStopBits =
          $enumDecode(_$SerialStopBitsEnumMap, json['serialStopBits'])
      ..serialParity = $enumDecode(_$SerialParityEnumMap, json['serialParity'])
      ..serialFlowControl =
          $enumDecode(_$SerialFlowControlEnumMap, json['serialFlowControl']);

Map<String, dynamic> _$RemoteDeviceSettingsToJson(
        RemoteDeviceSettings instance) =>
    <String, dynamic>{
      'deviceName': instance.deviceName,
      'type': _$RemoteDeviceTypeEnumMap[instance.type]!,
      'globalUnitId': instance.globalUnitId,
      'responseTimeout': instance.responseTimeout,
      'serverAdress': instance.serverAdress,
      'port': instance.port,
      'connectionTimeout': instance.connectionTimeout,
      'delayAfterConnect': instance.delayAfterConnect,
      'serialPortName': instance.serialPortName,
      'serialBaudRate': _$SerialBaudRateEnumMap[instance.serialBaudRate]!,
      'serialDataBits': _$SerialDataBitsEnumMap[instance.serialDataBits]!,
      'serialStopBits': _$SerialStopBitsEnumMap[instance.serialStopBits]!,
      'serialParity': _$SerialParityEnumMap[instance.serialParity]!,
      'serialFlowControl':
          _$SerialFlowControlEnumMap[instance.serialFlowControl]!,
    };

const _$RemoteDeviceTypeEnumMap = {
  RemoteDeviceType.tcp: 'tcp',
  RemoteDeviceType.udp: 'udp',
  RemoteDeviceType.serialRtu: 'serialRtu',
  RemoteDeviceType.serialAscii: 'serialAscii',
};

const _$SerialBaudRateEnumMap = {
  SerialBaudRate.b200: 'b200',
  SerialBaudRate.b300: 'b300',
  SerialBaudRate.b600: 'b600',
  SerialBaudRate.b1200: 'b1200',
  SerialBaudRate.b1800: 'b1800',
  SerialBaudRate.b2400: 'b2400',
  SerialBaudRate.b4800: 'b4800',
  SerialBaudRate.b9600: 'b9600',
  SerialBaudRate.b19200: 'b19200',
  SerialBaudRate.b28800: 'b28800',
  SerialBaudRate.b38400: 'b38400',
  SerialBaudRate.b57600: 'b57600',
  SerialBaudRate.b76800: 'b76800',
  SerialBaudRate.b115200: 'b115200',
  SerialBaudRate.b230400: 'b230400',
  SerialBaudRate.b460800: 'b460800',
  SerialBaudRate.b576000: 'b576000',
  SerialBaudRate.b921600: 'b921600',
};

const _$SerialDataBitsEnumMap = {
  SerialDataBits.bits5: 'bits5',
  SerialDataBits.bits6: 'bits6',
  SerialDataBits.bits7: 'bits7',
  SerialDataBits.bits8: 'bits8',
  SerialDataBits.bits9: 'bits9',
};

const _$SerialStopBitsEnumMap = {
  SerialStopBits.none: 'none',
  SerialStopBits.one: 'one',
  SerialStopBits.two: 'two',
};

const _$SerialParityEnumMap = {
  SerialParity.none: 'none',
  SerialParity.odd: 'odd',
  SerialParity.even: 'even',
  SerialParity.mark: 'mark',
  SerialParity.space: 'space',
};

const _$SerialFlowControlEnumMap = {
  SerialFlowControl.none: 'none',
  SerialFlowControl.xonXoff: 'xonXoff',
  SerialFlowControl.rtsCts: 'rtsCts',
  SerialFlowControl.dtrDsr: 'dtrDsr',
};
