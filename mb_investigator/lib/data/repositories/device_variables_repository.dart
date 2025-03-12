import 'package:mb_investigator/domain/models/device_variable.dart';
import 'package:mb_investigator/domain/models/device_variable_settings.dart';

class DeviceVariableRepository {
  final List<DeviceVariable> _deviceDataList = [];

  List<DeviceVariable> getDeviceVariables() => _deviceDataList;

  void addDeviceVariable(DeviceVariableSettings settings) {
    _deviceDataList.add(DeviceVariable(settings: settings));
  }

  void addDeviceVariables(List<DeviceVariableSettings> variables) {
    for (var variable in variables) {
      _deviceDataList.add(DeviceVariable(settings: variable));
    }
  }

  void replaceDeviceVariable(
      DeviceVariable deviceVar, DeviceVariableSettings settings) {
    var index = _deviceDataList.indexWhere((v) => identical(v, deviceVar));
    _deviceDataList.removeAt(index);
    _deviceDataList.insert(index, DeviceVariable(settings: settings));
  }

  void removeDeviceVariable(DeviceVariable deviceVar) async {
    _deviceDataList.removeWhere((v) => identical(v, deviceVar));
  }

  void removeAll() {
    _deviceDataList.clear();
  }

  void reorderDeviceVariableList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }
    final item = _deviceDataList.removeAt(oldIndex);
    _deviceDataList.insert(newIndex, item);
  }
}
