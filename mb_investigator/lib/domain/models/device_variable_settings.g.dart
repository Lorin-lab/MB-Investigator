// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_variable_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceVariableSettings _$DeviceVariableSettingsFromJson(
        Map<String, dynamic> json) =>
    DeviceVariableSettings()
      ..name = json['name'] as String
      ..registerAddress = (json['registerAddress'] as num).toInt()
      ..dataUnitCount = (json['dataUnitCount'] as num).toInt()
      ..modbusElementType = const ModbusElementTypeJsonConverter()
          .fromJson((json['modbusElementType'] as num).toInt())
      ..dataEncoding = $enumDecode(_$DataEncodingEnumMap, json['dataEncoding'])
      ..endianness = $enumDecode(_$ModbusEndiannessEnumMap, json['endianness']);

Map<String, dynamic> _$DeviceVariableSettingsToJson(
        DeviceVariableSettings instance) =>
    <String, dynamic>{
      'name': instance.name,
      'registerAddress': instance.registerAddress,
      'dataUnitCount': instance.dataUnitCount,
      'modbusElementType': const ModbusElementTypeJsonConverter()
          .toJson(instance.modbusElementType),
      'dataEncoding': _$DataEncodingEnumMap[instance.dataEncoding]!,
      'endianness': _$ModbusEndiannessEnumMap[instance.endianness]!,
    };

const _$DataEncodingEnumMap = {
  DataEncoding.raw: 'raw',
  DataEncoding.bool: 'bool',
  DataEncoding.unsignedInteger: 'unsignedInteger',
  DataEncoding.signedInteger: 'signedInteger',
  DataEncoding.float: 'float',
  DataEncoding.ascii: 'ascii',
};

const _$ModbusEndiannessEnumMap = {
  ModbusEndianness.ABCD: 'ABCD',
  ModbusEndianness.CDAB: 'CDAB',
  ModbusEndianness.BADC: 'BADC',
  ModbusEndianness.DCBA: 'DCBA',
};
