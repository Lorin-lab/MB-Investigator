// Import the test package and Counter class
import 'package:mb_investigator/domain/models/device_variable_settings.dart';
import 'package:test/test.dart';

void main() {
  test('registerAddress should accept range between 0 and 65535', () {
    final settings = DeviceVariableSettings();

    expect(() => settings.registerAddress = -1, throwsRangeError);
    expect(() => settings.registerAddress = 0, returnsNormally);
    expect(() => settings.registerAddress = 65535, returnsNormally);
    expect(() => settings.registerAddress = 65536, throwsRangeError);
  });

  test('dataUnitCount should accept range between 1 and 65535', () {
    final settings = DeviceVariableSettings();

    expect(() => settings.dataUnitCount = 0, throwsRangeError);
    expect(() => settings.dataUnitCount = 1, returnsNormally);
    expect(() => settings.dataUnitCount = 65535, returnsNormally);
    expect(() => settings.dataUnitCount = 65536, throwsRangeError);
  });
}
