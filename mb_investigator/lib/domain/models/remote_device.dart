import 'package:mb_investigator/domain/models/remote_device_settings.dart';
import 'package:modbus_client/modbus_client.dart';
import 'package:modbus_client_serial/modbus_client_serial.dart';
import 'package:modbus_client_tcp/modbus_client_tcp.dart';
import 'package:modbus_client_udp/modbus_client_udp.dart';

class RemoteDevice {
  // Constructor
  RemoteDevice({required RemoteDeviceSettings settings})
      : _settings = settings,
        _modbusClient = generateModbusClient(settings);

  // Settings
  final RemoteDeviceSettings _settings;
  RemoteDeviceSettings get settings => RemoteDeviceSettings.clone(_settings);
  final ModbusClient _modbusClient;

  ModbusClient getModbusClient() {
    return _modbusClient;
  }

  /// Instance the right [ModbusClient] from the settings of the device.
  static ModbusClient generateModbusClient(RemoteDeviceSettings settings) {
    const ModbusConnectionMode modbusConnectionMode =
        ModbusConnectionMode.autoConnectAndKeepConnected;

    return switch (settings.type) {
      RemoteDeviceType.tcp => ModbusClientTcp(settings.serverAdress,
          serverPort: settings.port,
          unitId: settings.globalUnitId,
          connectionMode: modbusConnectionMode,
          connectionTimeout: Duration(seconds: settings.connectionTimeout),
          delayAfterConnect: Duration(seconds: settings.delayAfterConnect),
          responseTimeout: Duration(seconds: settings.responseTimeout)),
      RemoteDeviceType.udp => ModbusClientUdp(settings.serverAdress,
          serverPort: settings.port,
          unitId: settings.globalUnitId,
          connectionMode: modbusConnectionMode,
          connectionTimeout: Duration(seconds: settings.connectionTimeout),
          delayAfterConnect: Duration(seconds: settings.delayAfterConnect),
          responseTimeout: Duration(seconds: settings.responseTimeout)),
      RemoteDeviceType.serialRtu => ModbusClientSerialRtu(
          portName: settings.serialPortName,
          baudRate: settings.serialBaudRate,
          dataBits: settings.serialDataBits,
          stopBits: settings.serialStopBits,
          parity: settings.serialParity,
          flowControl: settings.serialFlowControl,
          connectionMode: modbusConnectionMode,
          responseTimeout: Duration(seconds: settings.responseTimeout),
          unitId: settings.globalUnitId),
      RemoteDeviceType.serialAscii => ModbusClientSerialAscii(
          portName: settings.serialPortName,
          baudRate: settings.serialBaudRate,
          dataBits: settings.serialDataBits,
          stopBits: settings.serialStopBits,
          parity: settings.serialParity,
          flowControl: settings.serialFlowControl,
          connectionMode: modbusConnectionMode,
          responseTimeout: Duration(seconds: settings.responseTimeout),
          unitId: settings.globalUnitId,
        ),
    };
  }
}
