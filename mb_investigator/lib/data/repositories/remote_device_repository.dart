import 'package:mb_investigator/domain/models/remote_device.dart';
import 'package:mb_investigator/domain/models/remote_device_settings.dart';

class RemoteDeviceRepository {
  RemoteDevice _remoteDevice = RemoteDevice(settings: RemoteDeviceSettings());

  RemoteDevice getRemoteDevice() => _remoteDevice;

  void changeRemoteDeviceSettings(RemoteDeviceSettings settings) {
    _remoteDevice = RemoteDevice(settings: settings);
  }
}
