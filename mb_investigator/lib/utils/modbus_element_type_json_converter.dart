import 'package:json_annotation/json_annotation.dart';
import 'package:modbus_client/modbus_client.dart';

class ModbusElementTypeJsonConverter
    implements JsonConverter<ModbusElementType, int> {
  const ModbusElementTypeJsonConverter();

  @override
  ModbusElementType fromJson(int json) => switch (json) {
        1 => ModbusElementType.coil,
        2 => ModbusElementType.discreteInput,
        3 => ModbusElementType.holdingRegister,
        4 => ModbusElementType.inputRegister,
        _ => throw FormatException(
            "Value $json can not be parse to ModbusElementType."),
      };

  @override
  int toJson(ModbusElementType object) => object.readFunction.code;
}
