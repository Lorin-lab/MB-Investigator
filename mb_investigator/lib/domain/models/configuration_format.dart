// ignore_for_file: constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'package:mb_investigator/domain/models/device_variable_settings.dart';
import 'package:mb_investigator/domain/models/remote_device_settings.dart';

part 'configuration_format.g.dart';

/// Cette class a pour but d'être un bundle de la configuration
/// qui peut être importer ou exporter au format JSON.
@JsonSerializable()
class ConfigurationFormat {
  static const FORMAT_VERSION = 1;

  int formatVersion = FORMAT_VERSION;
  DateTime exportDate = DateTime.now();
  RemoteDeviceSettings remoteDeviceSettings = RemoteDeviceSettings();
  List<DeviceVariableSettings> deviceVariablesSettings = [];

  /// Constructors
  ConfigurationFormat();

  ConfigurationFormat.fromSettings(
      {required this.remoteDeviceSettings,
      required this.deviceVariablesSettings});

  factory ConfigurationFormat.fromJson(Map<String, dynamic> json) =>
      _$ConfigurationFormatFromJson(json);

  Map<String, dynamic> toJson() => _$ConfigurationFormatToJson(this);
}
