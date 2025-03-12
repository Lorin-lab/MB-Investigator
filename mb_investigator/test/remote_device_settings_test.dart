// Import the test package and Counter class
import 'package:mb_investigator/domain/models/remote_device_settings.dart';
import 'package:test/test.dart';

void main() {
  test('Should give a deep copy of the settings', () {
    final settings = RemoteDeviceSettings();
    settings.deviceName = "a name";
    final settings2 = RemoteDeviceSettings.clone(settings);

    expect(settings.deviceName, settings2.deviceName);

    settings.deviceName = "new name";
    expect(settings.deviceName, isNot(settings2.deviceName));
  });

  /*test('Settings should generate the right client according to the type', () {
    final settings = RemoteDeviceSettings();

    settings.type = RemoteDeviceType.tcp;
    expect(settings.generateModbusClient().runtimeType, ModbusClientTcp);
    settings.type = RemoteDeviceType.udp;
    expect(() => settings.generateModbusClient().runtimeType,
        throwsUnimplementedError);
    settings.type = RemoteDeviceType.serialRtu;
    expect(settings.generateModbusClient().runtimeType, ModbusClientSerialRtu);
    settings.type = RemoteDeviceType.serialAscii;
    expect(
        settings.generateModbusClient().runtimeType, ModbusClientSerialAscii);
  });*/

  test('globalUnitId should accept range between 0 and 254', () {
    final settings = RemoteDeviceSettings();

    expect(() => settings.globalUnitId = -1, throwsRangeError);
    expect(() => settings.globalUnitId = 0, returnsNormally);
    expect(() => settings.globalUnitId = 254, returnsNormally);
    expect(() => settings.globalUnitId = 255, throwsRangeError);
  });

  test('responseTimeout should not accept value lower than 1 ', () {
    final settings = RemoteDeviceSettings();

    expect(() => settings.responseTimeout = 0, throwsRangeError);
    expect(() => settings.responseTimeout = 1, returnsNormally);
    expect(() => settings.responseTimeout = 254, returnsNormally);
  });

  test('port should accept range between 0 and 65535', () {
    final settings = RemoteDeviceSettings();

    expect(() => settings.port = -1, throwsRangeError);
    expect(() => settings.port = 0, returnsNormally);
    expect(() => settings.port = 65535, returnsNormally);
    expect(() => settings.port = 65536, throwsRangeError);
  });

  test('connectionTimeout should not accept value lower than 1 ', () {
    final settings = RemoteDeviceSettings();

    expect(() => settings.connectionTimeout = 0, throwsRangeError);
    expect(() => settings.connectionTimeout = 1, returnsNormally);
    expect(() => settings.connectionTimeout = 254, returnsNormally);
  });

  test('delayAfterConnect should not accept value lower than 1 ', () {
    final settings = RemoteDeviceSettings();

    expect(() => settings.delayAfterConnect = 0, throwsRangeError);
    expect(() => settings.delayAfterConnect = 1, returnsNormally);
    expect(() => settings.delayAfterConnect = 254, returnsNormally);
  });
}
