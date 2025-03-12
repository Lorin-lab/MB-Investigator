import 'dart:convert';
import 'dart:typed_data';

import 'package:mb_investigator/domain/models/data_representation/data_representation.dart';
import 'package:modbus_client/modbus_client.dart';

class AsciiRepresentation implements DataRepresentation {
  @override
  bool get supportBitTypeRegister => false;

  @override
  bool get supportWordTypeRegister => true;

  @override
  bool supportDataUnitCount(int count) {
    if (1 <= count && count <= 200) {
      return true;
    }
    return false;
  }

  @override
  Uint8List encodeValue(
      String inputText, ModbusEndianness endianness, int dataUnitCount) {
    inputText = inputText.padLeft(dataUnitCount, '\u0000');
    return ascii.encoder.convert(inputText, 0, dataUnitCount);
  }

  @override
  String getFormatedValue(
      Uint8List rawValues, ModbusEndianness endianness, int dataUnitCount) {
    var text = "";
    for (var i in rawValues) {
      if (i != 0) text += String.fromCharCode(i);
    }
    return text;
  }
}
