import 'dart:typed_data';

import 'package:mb_investigator/domain/models/data_representation/data_representation.dart';
import 'package:modbus_client/modbus_client.dart';

class RawRepresentation implements DataRepresentation {
  @override
  bool get supportBitTypeRegister => true;

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
    throw UnimplementedError();
  }

  @override
  String getFormatedValue(
      Uint8List rawValues, ModbusEndianness endianness, int dataUnitCount) {
    var words = Uint16List.view(rawValues.buffer);
    var text = "0x";
    int count = 0;
    for (var i in words) {
      text += i.toRadixString(16).padLeft(4, '0');
      count++;
      if (count % 1 == 0) {
        text += " ";
      }
    }
    return text;
  }
}
