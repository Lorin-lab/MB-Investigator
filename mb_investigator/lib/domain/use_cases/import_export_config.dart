import 'dart:convert';

import 'package:mb_investigator/data/repositories/device_variables_repository.dart';
import 'package:mb_investigator/data/repositories/remote_device_repository.dart';
import 'package:mb_investigator/domain/models/configuration_format.dart';

class ImportExportConfig {
  ImportExportConfig({
    required RemoteDeviceRepository remoteDeviceRepository,
    required DeviceVariableRepository deviceVariableRepository,
  })  : _remoteDeviceRepository = remoteDeviceRepository,
        _deviceVariableRepository = deviceVariableRepository;

  final RemoteDeviceRepository _remoteDeviceRepository;
  final DeviceVariableRepository _deviceVariableRepository;

  void importConfiguration(Map<String, dynamic> json) {
    var formatVersion = json["formatVersion"];
    if (formatVersion == null || formatVersion < 1) {
      throw FormatException(
          "JSON data seems to be structured in an unsupported format (format_version == $formatVersion)");
    } else if (formatVersion > ConfigurationFormat.FORMAT_VERSION) {
      throw FormatException(
          "This configuration was saved with a more recent version of MB-investigator and cannot be imported. (format_version == $formatVersion)");
    }

    var config = ConfigurationFormat.fromJson(json);

    _remoteDeviceRepository
        .changeRemoteDeviceSettings(config.remoteDeviceSettings);
    _deviceVariableRepository.removeAll();
    _deviceVariableRepository
        .addDeviceVariables(config.deviceVariablesSettings);
  }

  Map<String, dynamic> exportConfiguration() {
    var config = ConfigurationFormat.fromSettings(
        remoteDeviceSettings:
            _remoteDeviceRepository.getRemoteDevice().settings,
        deviceVariablesSettings: _deviceVariableRepository
            .getDeviceVariables()
            .map((e) => e.settings)
            .toList());

    return config.toJson();
  }

  String exportConfigurationPrettyString() {
    Map<String, dynamic> json = exportConfiguration();
    const encoder = JsonEncoder.withIndent("  ");
    return encoder.convert(json);
  }
}
