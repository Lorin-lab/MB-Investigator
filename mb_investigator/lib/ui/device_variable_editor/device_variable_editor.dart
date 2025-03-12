import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:mb_investigator/domain/models/device_variable_settings.dart';
import 'package:mb_investigator/ui/core/settings_group_widget.dart';
import 'package:modbus_client/modbus_client.dart';
import 'package:mb_investigator/utils/extenstions.dart';

class DeviceVariableEditor extends StatefulWidget {
  final DeviceVariableSettings settings;
  final void Function(DeviceVariableSettings settings) validationCallback;
  const DeviceVariableEditor(
      {super.key, required this.settings, required this.validationCallback});

  @override
  State<DeviceVariableEditor> createState() => _DeviceVariableEditorState();
}

class _DeviceVariableEditorState extends State<DeviceVariableEditor> {
  _DeviceVariableEditorState();

  late DeviceVariableSettings newSettings;
  bool settingsVarSet = false;

  @override
  Widget build(BuildContext context) {
    if (settingsVarSet == false) {
      newSettings = DeviceVariableSettings.clone(widget.settings);
      settingsVarSet = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Device variable edition"),
        actions: [
          TextButton(
              onPressed: () {
                widget.validationCallback(newSettings);
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
          width: 500,
          child: Wrap(
            children: [
              SettingsGroupWidget(
                groupeName: "General",
                children: [
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Variable name"),
                    onChanged: (newValue) {
                      newSettings.name = newValue;
                    },
                    initialValue: newSettings.name,
                  ),
                ],
              ),
              SettingsGroupWidget(
                groupeName: "Register access",
                children: [
                  DropdownMenu<ModbusElementType>(
                    initialSelection: newSettings.modbusElementType,
                    requestFocusOnTap: true,
                    label: const Text('Reading function'),
                    dropdownMenuEntries: ModbusElementType.coil.values
                        .map<DropdownMenuEntry<ModbusElementType>>(
                            (ModbusElementType type) {
                      return DropdownMenuEntry<ModbusElementType>(
                        value: type,
                        label: type.name,
                      );
                    }).toList(),
                    onSelected: (value) {
                      setState(() {
                        newSettings.modbusElementType =
                            value ?? newSettings.modbusElementType;
                      });
                    },
                  ),
                  TextFormField(
                    decoration: const InputDecoration(labelText: "Address"),
                    keyboardType: TextInputType.number,
                    onChanged: (newValue) {
                      newSettings.registerAddress = int.tryParse(newValue) ?? 0;
                    },
                    initialValue: newSettings.registerAddress.toString(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    validator: null,
                  ),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: "Word/bit count"),
                    keyboardType: TextInputType.number,
                    onChanged: (newValue) {
                      newSettings.dataUnitCount = int.tryParse(newValue) ?? 1;
                    },
                    initialValue: newSettings.dataUnitCount.toString(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                  ),
                ],
              ),
              SettingsGroupWidget(groupeName: "Data Representation", children: [
                DropdownMenu<DataEncoding>(
                  initialSelection: newSettings.dataEncoding,
                  requestFocusOnTap: true,
                  label: const Text('Data encoding'),
                  dropdownMenuEntries: DataEncoding.values
                      .map<DropdownMenuEntry<DataEncoding>>(
                          (DataEncoding type) {
                    return DropdownMenuEntry<DataEncoding>(
                      value: type,
                      label: type.name,
                    );
                  }).toList(),
                  onSelected: (value) {
                    setState(() {
                      value ??= DataEncoding.raw; // set value if null
                      newSettings.dataEncoding = value!;
                    });
                  },
                ),
                Text(
                  getIncorretSettingsMsg(newSettings),
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                DropdownMenu<ModbusEndianness>(
                  initialSelection: newSettings.endianness,
                  requestFocusOnTap: true,
                  label: const Text('Endianness'),
                  dropdownMenuEntries: ModbusEndianness.values
                      .map<DropdownMenuEntry<ModbusEndianness>>(
                          (ModbusEndianness type) {
                    return DropdownMenuEntry<ModbusEndianness>(
                      value: type,
                      label: type.name,
                    );
                  }).toList(),
                  onSelected: (value) {
                    newSettings.endianness = value ?? ModbusEndianness.ABCD;
                  },
                ),
              ])
            ],
          ),
        ),
      ),
    );
  }

  String getIncorretSettingsMsg(DeviceVariableSettings settings) {
    if (settings.incompatibleElementType()) {
      return "The encoding '${settings.dataEncoding.name}' cannot be use with '${settings.modbusElementType.name}'";
    } else if (settings.incompatibleDataUnitCount()) {
      return "The encoding '${settings.dataEncoding.name}' cannot work with '${settings.dataUnitCount}' bit/word";
    }

    return "";
  }
}
