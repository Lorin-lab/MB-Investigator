// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'configuration_format.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ConfigurationFormat _$ConfigurationFormatFromJson(Map<String, dynamic> json) =>
    ConfigurationFormat()
      ..formatVersion = (json['formatVersion'] as num).toInt()
      ..exportDate = DateTime.parse(json['exportDate'] as String)
      ..remoteDeviceSettings = RemoteDeviceSettings.fromJson(
          json['remoteDeviceSettings'] as Map<String, dynamic>)
      ..deviceVariablesSettings = (json['deviceVariablesSettings']
              as List<dynamic>)
          .map(
              (e) => DeviceVariableSettings.fromJson(e as Map<String, dynamic>))
          .toList();

Map<String, dynamic> _$ConfigurationFormatToJson(
        ConfigurationFormat instance) =>
    <String, dynamic>{
      'formatVersion': instance.formatVersion,
      'exportDate': instance.exportDate.toIso8601String(),
      'remoteDeviceSettings': instance.remoteDeviceSettings,
      'deviceVariablesSettings': instance.deviceVariablesSettings,
    };
