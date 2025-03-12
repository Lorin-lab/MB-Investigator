import 'package:modbus_client/modbus_client.dart';

extension Enumeration on ModbusElementType {
  List<ModbusElementType> get values {
    return [
      ModbusElementType.coil,
      ModbusElementType.discreteInput,
      ModbusElementType.holdingRegister,
      ModbusElementType.inputRegister
    ];
  }

  String get name {
    return switch (readFunction) {
      ModbusFunctionCode.readCoils => "(0x01) Coils",
      ModbusFunctionCode.readDiscreteInputs => "(0x02) Discrete inputs",
      ModbusFunctionCode.readHoldingRegisters => "(0x03) Holding registers",
      ModbusFunctionCode.readInputRegisters => "(0x04) Input registers",
      _ => throw UnimplementedError(),
    };
  }
}
