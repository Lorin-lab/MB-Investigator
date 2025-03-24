// Import the test package and Counter class
import 'package:mb_investigator/utils/modbus_element_type_json_converter.dart';
import 'package:modbus_client/modbus_client.dart';
import 'package:test/test.dart';

void main() {
  test('should convert coil to 1 and vice-versa', () {
    const converter = ModbusElementTypeJsonConverter();
    var json = converter.toJson(ModbusElementType.coil);
    expect(json, 1);
    var object = converter.fromJson(json);
    expect(object, ModbusElementType.coil);
  });

  test('should convert discreteInput to 2 and vice-versa', () {
    const converter = ModbusElementTypeJsonConverter();
    var json = converter.toJson(ModbusElementType.discreteInput);
    expect(json, 2);
    var object = converter.fromJson(json);
    expect(object, ModbusElementType.discreteInput);
  });

  test('should convert holdingRegister to 3 and vice-versa', () {
    const converter = ModbusElementTypeJsonConverter();
    var json = converter.toJson(ModbusElementType.holdingRegister);
    expect(json, 3);
    var object = converter.fromJson(json);
    expect(object, ModbusElementType.holdingRegister);
  });

  test('should convert inputRegister to 4 and vice-versa', () {
    const converter = ModbusElementTypeJsonConverter();
    var json = converter.toJson(ModbusElementType.inputRegister);
    expect(json, 4);
    var object = converter.fromJson(json);
    expect(object, ModbusElementType.inputRegister);
  });
}
