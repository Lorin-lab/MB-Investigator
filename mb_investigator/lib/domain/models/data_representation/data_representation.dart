import 'dart:typed_data';

import 'package:modbus_client/modbus_client.dart';

abstract class DataRepresentation {
  bool get supportWordTypeRegister;

  bool get supportBitTypeRegister;

  bool supportDataUnitCount(int count);

  String getFormatedValue(
      Uint8List rawValues, ModbusEndianness endianness, int dataUnitCount);

  Uint8List encodeValue(
      String inputText, ModbusEndianness endianness, int dataUnitCount);
}
