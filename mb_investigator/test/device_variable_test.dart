// Import the test package and Counter class
import 'package:mb_investigator/domain/models/device_variable.dart';
import 'package:mb_investigator/domain/models/device_variable_settings.dart';
import 'package:test/test.dart';

void main() {
  test('should give a copy of the settings', () {
    final deviceVariable = DeviceVariable(settings: DeviceVariableSettings());
    var copy1 = deviceVariable.settings;
    copy1.registerAddress += 1;
    var copy2 = deviceVariable.settings;

    expect(copy1.registerAddress, isNot(copy2.registerAddress));
    expect(identical(copy1, copy2), isFalse);
  });
}
