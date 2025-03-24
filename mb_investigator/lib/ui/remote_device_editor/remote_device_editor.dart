import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mb_investigator/domain/models/remote_device_settings.dart';
import 'package:mb_investigator/ui/device_variable_listing/device_variable_listing_viewmodel.dart';
import 'package:mb_investigator/ui/core/settings_group_widget.dart';
import 'package:modbus_client_serial/modbus_client_serial.dart';
import 'package:provider/provider.dart';
import 'package:libserialport/libserialport.dart';

class RemoteDeviceEditor extends StatefulWidget {
  final RemoteDeviceSettings settings;

  const RemoteDeviceEditor(this.settings, {super.key});

  @override
  State<RemoteDeviceEditor> createState() => _RemoteDeviceEditorState();
}

class _RemoteDeviceEditorState extends State<RemoteDeviceEditor> {
  _RemoteDeviceEditorState();

  late RemoteDeviceSettings modifiedSettings;
  bool once = true;

  @override
  Widget build(BuildContext context) {
    if (once) {
      modifiedSettings = RemoteDeviceSettings.clone(widget.settings);
      once = false;
    }
    return Scaffold(
        appBar: AppBar(
          title: const Text("Remote device edition"),
          actions: [
            TextButton(
                onPressed: () {
                  // ignore: unused_local_variable
                  var modbusProvider =
                      Provider.of<DeviceVariableListingViewModel>(context,
                          listen: false);

                  modbusProvider.changeClient(modifiedSettings);
                  Navigator.pop(context);
                },
                child: const Text("Valid")),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Cancel")),
          ],
        ),
        body: Center(
          child: SizedBox(
            width: 400,
            child: Column(
              children: getSettingsList(),
            ),
          ),
        ));
  }

  List<Widget> getSettingsList() {
    List<Widget> list = [];
    list.add(_GeneralSettings(modifiedSettings, setState));
    if (modifiedSettings.type == RemoteDeviceType.tcp ||
        modifiedSettings.type == RemoteDeviceType.udp) {
      list.add(_IpSettings(settings: modifiedSettings));
    }
    if (modifiedSettings.type == RemoteDeviceType.serialRtu ||
        modifiedSettings.type == RemoteDeviceType.serialAscii) {
      list.add(_SerialSettings(settings: modifiedSettings));
    }
    return list;
  }
}

class _GeneralSettings extends StatelessWidget {
  const _GeneralSettings(this.settings, this.parentSetState);

  final RemoteDeviceSettings settings;
  final void Function(VoidCallback fn) parentSetState;

  @override
  Widget build(BuildContext context) {
    return SettingsGroupWidget(
      groupeName: "General",
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Device name"),
          onChanged: (newValue) => settings.deviceName = newValue,
          initialValue: settings.deviceName,
        ),
        DropdownMenu<RemoteDeviceType>(
          initialSelection: settings.type,
          requestFocusOnTap: true,
          label: const Text('Connection type'),
          dropdownMenuEntries: RemoteDeviceType.values
              .map<DropdownMenuEntry<RemoteDeviceType>>(
                  (RemoteDeviceType type) {
            return DropdownMenuEntry<RemoteDeviceType>(
              value: type,
              label: type.name,
            );
          }).toList(),
          onSelected: (value) {
            parentSetState(() {
              settings.type = value ?? RemoteDeviceType.tcp;
            });
          },
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Unit id"),
          keyboardType: TextInputType.number,
          initialValue: settings.globalUnitId.toString(),
          onChanged: (newValue) {
            settings.globalUnitId = int.tryParse(newValue) ?? 1;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Reponse timeout (sec)"),
          keyboardType: TextInputType.number,
          initialValue: settings.responseTimeout.toString(),
          onChanged: (newValue) {
            settings.responseTimeout = int.tryParse(newValue) ?? 5;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
      ],
    );
  }
}

class _IpSettings extends StatelessWidget {
  const _IpSettings({
    required this.settings,
  });

  final RemoteDeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    return SettingsGroupWidget(
      groupeName: "Ethernet",
      children: [
        TextFormField(
          decoration: const InputDecoration(labelText: "Ip or hostname"),
          onChanged: (newValue) => settings.serverAdress = newValue,
          initialValue: settings.serverAdress,
        ),
        TextFormField(
          decoration: const InputDecoration(labelText: "Port number"),
          keyboardType: TextInputType.number,
          initialValue: settings.port.toString(),
          onChanged: (newValue) {
            settings.port = int.tryParse(newValue) ?? 502;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        TextFormField(
          decoration:
              const InputDecoration(labelText: "Connection timeout (sec)"),
          keyboardType: TextInputType.number,
          initialValue: settings.connectionTimeout.toString(),
          onChanged: (newValue) {
            settings.connectionTimeout = int.tryParse(newValue) ?? 5;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
        TextFormField(
          decoration:
              const InputDecoration(labelText: "Delay after connect (sec)"),
          keyboardType: TextInputType.number,
          initialValue: settings.delayAfterConnect.toString(),
          onChanged: (newValue) {
            settings.delayAfterConnect = int.tryParse(newValue) ?? 1;
          },
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.digitsOnly
          ],
        ),
      ],
    );
  }
}

class _SerialSettings extends StatelessWidget {
  const _SerialSettings({
    required this.settings,
  });

  final RemoteDeviceSettings settings;

  @override
  Widget build(BuildContext context) {
    List<String> portList = [];
    bool portFound = true;
    String? portErrorText;

    try {
      portList.addAll(SerialPort.availablePorts);
      // ignore: empty_catches
    } catch (e) {}
    if (portList.isEmpty) {
      portList.add("n/a");
      portErrorText = "No port found.";
      portFound = false;
    }
    String initialSelection = portList.firstWhere(
        (s) => s == settings.serialPortName,
        orElse: () => portList.first);

    return SettingsGroupWidget(
      groupeName: "Serial",
      children: [
        DropdownMenu<String>(
          initialSelection: initialSelection,
          enabled: portFound,
          requestFocusOnTap: true,
          label: const Text('Port serial'),
          hintText: "Port name",
          errorText: portErrorText,
          dropdownMenuEntries:
              portList.map<DropdownMenuEntry<String>>((String port) {
            return DropdownMenuEntry<String>(
              value: port,
              label: port,
            );
          }).toList(),
          onSelected: (value) => settings.serialPortName = value ?? "",
        ),
        DropdownMenu<SerialBaudRate>(
          initialSelection: settings.serialBaudRate,
          requestFocusOnTap: true,
          label: const Text('Baud rate'),
          dropdownMenuEntries: SerialBaudRate.values
              .map<DropdownMenuEntry<SerialBaudRate>>((SerialBaudRate item) {
            return DropdownMenuEntry<SerialBaudRate>(
              value: item,
              label: item.intValue.toString(),
            );
          }).toList(),
          onSelected: (value) =>
              settings.serialBaudRate = value ?? SerialBaudRate.b9600,
        ),
        DropdownMenu<SerialDataBits>(
          initialSelection: settings.serialDataBits,
          requestFocusOnTap: true,
          label: const Text('Data bits'),
          dropdownMenuEntries: SerialDataBits.values
              .map<DropdownMenuEntry<SerialDataBits>>((SerialDataBits item) {
            return DropdownMenuEntry<SerialDataBits>(
              value: item,
              label: item.intValue.toString(),
            );
          }).toList(),
          onSelected: (value) =>
              settings.serialDataBits = value ?? SerialDataBits.bits8,
        ),
        DropdownMenu<SerialStopBits>(
          initialSelection: settings.serialStopBits,
          requestFocusOnTap: true,
          label: const Text('Stop bits'),
          dropdownMenuEntries: SerialStopBits.values
              .map<DropdownMenuEntry<SerialStopBits>>((SerialStopBits item) {
            return DropdownMenuEntry<SerialStopBits>(
              value: item,
              label: item.intValue.toString(),
            );
          }).toList(),
          onSelected: (value) =>
              settings.serialStopBits = value ?? SerialStopBits.none,
        ),
        DropdownMenu<SerialParity>(
          initialSelection: settings.serialParity,
          requestFocusOnTap: true,
          label: const Text('Parity'),
          dropdownMenuEntries: SerialParity.values
              .map<DropdownMenuEntry<SerialParity>>((SerialParity item) {
            return DropdownMenuEntry<SerialParity>(
              value: item,
              label: item.name,
            );
          }).toList(),
          onSelected: (value) =>
              settings.serialParity = value ?? SerialParity.none,
        ),
        DropdownMenu<SerialFlowControl>(
          initialSelection: settings.serialFlowControl,
          requestFocusOnTap: true,
          label: const Text('Flow controle'),
          dropdownMenuEntries: SerialFlowControl.values
              .map<DropdownMenuEntry<SerialFlowControl>>(
                  (SerialFlowControl item) {
            return DropdownMenuEntry<SerialFlowControl>(
              value: item,
              label: item.name,
            );
          }).toList(),
          onSelected: (value) =>
              settings.serialFlowControl = value ?? SerialFlowControl.none,
        ),
      ],
    );
  }
}
