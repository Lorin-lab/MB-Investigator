import 'dart:typed_data';

import 'package:modbus_client/modbus_client.dart';

class ModbusRawElement extends ModbusElement<Uint8List> {
  ModbusRawElement(
      {required super.name,
      required super.type,
      required super.address,
      required super.byteCount});

  @override
  Uint8List? setValueFromBytes(Uint8List rawValues) {
    return value = rawValues;
  }

  @override
  ModbusWriteRequest getWriteRequest(value,
      {bool rawValue = true,
      int? unitId,
      Duration? responseTimeout,
      ModbusEndianness? endianness}) {
    return super.getMultipleWriteRequest(value,
        unitId: unitId,
        responseTimeout: responseTimeout,
        endianness: endianness);
  }
}
