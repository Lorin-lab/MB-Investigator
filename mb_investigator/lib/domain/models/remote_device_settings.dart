import 'package:modbus_client_serial/modbus_client_serial.dart';
import 'package:json_annotation/json_annotation.dart';

part 'remote_device_settings.g.dart';

@JsonSerializable()
class RemoteDeviceSettings {
  /// Commun settings
  String deviceName = "New device";

  RemoteDeviceType type = RemoteDeviceType.tcp;

  int _globalUnitId = 1;
  int get globalUnitId => _globalUnitId;
  set globalUnitId(int value) {
    if (value < 0 || value > 254) {
      throw RangeError("globalUnitId must be between 0 and 254");
    }
    _globalUnitId = value;
  }

  int _responseTimeout = 5;
  int get responseTimeout => _responseTimeout;
  set responseTimeout(int value) {
    if (value < 1) {
      throw RangeError("responseTimeout must be greater than 0");
    }
    _responseTimeout = value;
  }

  /// TCP/IP settings
  String serverAdress = "127.0.0.1";

  int _port = 502;
  int get port => _port;
  set port(int value) {
    if (value < 0 || value > 65535) {
      throw RangeError("port must be between 0 and 65535");
    }
    _port = value;
  }

  int _connectionTimeout = 5; //seconde
  int get connectionTimeout => _connectionTimeout;
  set connectionTimeout(int value) {
    if (value < 1) {
      throw RangeError("connectionTimeout must be greater than 0");
    }
    _connectionTimeout = value;
  }

  int _delayAfterConnect = 1; //seconde
  int get delayAfterConnect => _delayAfterConnect;
  set delayAfterConnect(int value) {
    if (value < 1) {
      throw RangeError("delayAfterConnect must be greater than 0");
    }
    _delayAfterConnect = value;
  }

  /// Serial
  String serialPortName = "";
  SerialBaudRate serialBaudRate = SerialBaudRate.b9600;
  SerialDataBits serialDataBits = SerialDataBits.bits8;
  SerialStopBits serialStopBits = SerialStopBits.one;
  SerialParity serialParity = SerialParity.none;
  SerialFlowControl serialFlowControl = SerialFlowControl.none;

  /// Constructors
  RemoteDeviceSettings();

  factory RemoteDeviceSettings.fromJson(Map<String, dynamic> json) =>
      _$RemoteDeviceSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$RemoteDeviceSettingsToJson(this);

  factory RemoteDeviceSettings.clone(RemoteDeviceSettings settings) {
    return RemoteDeviceSettings.fromJson(settings.toJson());
  }
}

enum RemoteDeviceType {
  tcp,
  udp,
  serialRtu,
  serialAscii,
}
