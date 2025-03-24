import 'package:mb_investigator/domain/models/data_representation/ascii_representation.dart';
import 'package:mb_investigator/domain/models/data_representation/bool_representation.dart';
import 'package:mb_investigator/domain/models/data_representation/data_representation.dart';
import 'package:mb_investigator/domain/models/data_representation/float_representation.dart';
import 'package:mb_investigator/domain/models/data_representation/int_representation.dart';
import 'package:mb_investigator/domain/models/data_representation/raw_representation.dart';
import 'package:mb_investigator/domain/models/data_representation/uint_representation.dart';
import 'package:mb_investigator/utils/modbus_element_type_json_converter.dart';
import 'package:modbus_client/modbus_client.dart';
import 'package:json_annotation/json_annotation.dart';

part 'device_variable_settings.g.dart';

@JsonSerializable()
class DeviceVariableSettings {
  /// Settings data
  String name = "new variable";

  int _registerAddress = 0;
  int get registerAddress => _registerAddress;
  set registerAddress(int value) {
    if (value < 0 || value > 65535) {
      throw RangeError("registerAddress must be between 0 and 65535");
    }
    _registerAddress = value;
  }

  int _dataUnitCount = 1; // bit/word count;
  int get dataUnitCount => _dataUnitCount;
  set dataUnitCount(int value) {
    if (value < 1 || value > 65535) {
      throw RangeError("dataUnitCount must be between 1 and 65535");
    }
    _dataUnitCount = value;
  }

  @ModbusElementTypeJsonConverter()
  ModbusElementType modbusElementType = ModbusElementType.holdingRegister;

  DataEncoding dataEncoding = DataEncoding.raw;

  ModbusEndianness endianness = ModbusEndianness.ABCD;

  /// Constructors
  DeviceVariableSettings(); // with default values

  factory DeviceVariableSettings.fromJson(Map<String, dynamic> json) =>
      _$DeviceVariableSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$DeviceVariableSettingsToJson(this);

  factory DeviceVariableSettings.clone(DeviceVariableSettings settings) {
    return DeviceVariableSettings.fromJson(settings.toJson());
  }

  DataRepresentation getDataRepresentation() {
    return switch (dataEncoding) {
      DataEncoding.raw => RawRepresentation(),
      DataEncoding.bool => BoolRepresentation(),
      DataEncoding.unsignedInteger => UintRepresentation(),
      DataEncoding.signedInteger => IntRepresentation(),
      DataEncoding.float => FloatRepresentation(),
      DataEncoding.ascii => AsciiRepresentation(),
    };
  }

  bool isNotProperlyConfigured() {
    return incompatibleElementType() || incompatibleDataUnitCount();
  }

  bool incompatibleElementType() {
    if (modbusElementType.isBit &&
        !(getDataRepresentation().supportBitTypeRegister)) {
      return true;
    } else if (modbusElementType.isRegister &&
        !(getDataRepresentation().supportWordTypeRegister)) {
      return true;
    }
    return false;
  }

  bool incompatibleDataUnitCount() {
    return !getDataRepresentation().supportDataUnitCount(dataUnitCount);
  }
}

enum DataEncoding {
  raw,
  bool,
  unsignedInteger,
  signedInteger,
  float,
  ascii;
}
