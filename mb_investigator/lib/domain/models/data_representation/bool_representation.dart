import 'dart:typed_data';

import 'package:mb_investigator/domain/models/data_representation/data_representation.dart';
import 'package:modbus_client/modbus_client.dart';

class BoolRepresentation implements DataRepresentation {
  @override
  bool get supportBitTypeRegister => true;

  @override
  bool get supportWordTypeRegister => true;

  @override
  bool supportDataUnitCount(int count) => switch (count) {
        1 => true, // 1 bit
        _ => false
      };

  @override
  Uint8List encodeValue(
      String inputText, ModbusEndianness endianness, int dataUnitCount) {
    return switch (inputText.toUpperCase()) {
      "TRUE" => Uint8List(2)..buffer.asByteData().setUint8(1, 0x01),
      "FALSE" => Uint8List(2)..buffer.asByteData().setUint8(1, 0x00),
      _ => throw const FormatException("expect 'TRUE' or 'FALSE'")
    };
  }

  @override
  String getFormatedValue(
      Uint8List rawValues, ModbusEndianness endianness, int dataUnitCount) {
    if (rawValues.buffer.asByteData().getUint16(0) == 0) {
      return "False";
    } else {
      return "True";
    }
  }
}
