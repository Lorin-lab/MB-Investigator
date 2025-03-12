import 'dart:typed_data';

import 'package:mb_investigator/domain/models/data_representation/data_representation.dart';
import 'package:modbus_client/modbus_client.dart';

class IntRepresentation implements DataRepresentation {
  @override
  bool get supportBitTypeRegister => false;

  @override
  bool get supportWordTypeRegister => true;

  @override
  bool supportDataUnitCount(int count) => switch (count) {
        1 || 2 || 4 => true, // 16 or 32 or 64 bits
        _ => false
      };

  @override
  Uint8List encodeValue(
      String inputText, ModbusEndianness endianness, int dataUnitCount) {
    var integer = int.parse(inputText);
    var endian = endianness.swapByte ? Endian.little : Endian.big;
    return switch (dataUnitCount) {
      1 => Uint8List(2)..buffer.asByteData().setInt16(0, integer, endian),
      2 => Uint8List(4)..buffer.asByteData().setInt32(0, integer, endian),
      4 => Uint8List(8)..buffer.asByteData().setInt64(0, integer, endian),
      _ => throw UnsupportedError("Invalide dataUnitCount")
    };
  }

  @override
  String getFormatedValue(
      Uint8List rawValues, ModbusEndianness endianness, int dataUnitCount) {
    var data = rawValues.buffer.asByteData();
    var endian = endianness.swapByte ? Endian.little : Endian.big;
    var integer = switch (dataUnitCount) {
      1 => data.getInt16(0, endian),
      2 => data.getInt32(0, endian),
      4 => data.getInt64(0, endian),
      _ => throw UnsupportedError("Invalide dataUnitCount")
    };
    return integer.toString();
  }
}
