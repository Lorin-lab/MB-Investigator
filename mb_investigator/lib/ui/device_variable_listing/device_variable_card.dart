import 'package:flutter/material.dart';
import 'package:mb_investigator/domain/models/device_variable.dart';
import 'package:mb_investigator/ui/device_variable_editor/device_variable_editor.dart';
import 'package:mb_investigator/ui/device_variable_listing/device_variable_listing_viewmodel.dart';
import 'package:modbus_client/modbus_client.dart';
import 'package:provider/provider.dart';

class DeviceVariableCard extends StatelessWidget {
  final DeviceVariable deviceVariable;

  const DeviceVariableCard({super.key, required this.deviceVariable});

  @override
  Widget build(BuildContext context) {
    var viewModel =
        Provider.of<DeviceVariableListingViewModel>(context, listen: false);
    return Card(
      elevation: 2,
      child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
        if (constraints.maxWidth < 600) {
          return Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Padding(padding: EdgeInsets.only(left: 10)),
                    SizedBox(width: 50, child: getRegisterAddressWidget()),
                    SizedBox(width: 100, child: getVarNameWidget())
                  ],
                ),
                Row(
                  children: [
                    ...getActionButtonsWidgets(viewModel, context),
                    const Padding(padding: EdgeInsets.only(left: 20)),
                  ],
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable: deviceVariable.state,
                      builder: (context, state, child) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            getVarValueWidget(viewModel, context),
                            const Padding(padding: EdgeInsets.only(left: 10)),
                            Expanded(
                              child: SizedBox(
                                  width: 200,
                                  child: getDeviceVarialeStatusIndicator(
                                      deviceVariable, context)),
                            ),
                          ],
                        );
                      }),
                ),
              ],
            ),
            const Padding(padding: EdgeInsets.only(bottom: 5)),
          ]);
        }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Padding(padding: EdgeInsets.only(left: 10)),
                SizedBox(width: 50, child: getRegisterAddressWidget()),
                SizedBox(width: 100, child: getVarNameWidget()),
              ],
            ),
            Expanded(
              child: ValueListenableBuilder(
                  valueListenable: deviceVariable.state,
                  builder: (context, state, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        getVarValueWidget(viewModel, context),
                        const Padding(padding: EdgeInsets.only(left: 10)),
                        Expanded(
                          child: SizedBox(
                              width: 200,
                              child: getDeviceVarialeStatusIndicator(
                                  deviceVariable, context)),
                        ),
                      ],
                    );
                  }),
            ),
            Row(
              children: [
                ...getActionButtonsWidgets(viewModel, context),
                const Padding(padding: EdgeInsets.only(left: 30)),
              ],
            ),
          ],
        );
      }),
    );
  }

  Expanded getVarValueWidget(
      DeviceVariableListingViewModel viewModel, BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: () => viewModel.writeVar(context, deviceVariable),
      child: Container(
        padding: const EdgeInsets.all(4),
        margin: const EdgeInsets.only(left: 10),
        decoration: const BoxDecoration(
            color: Color.fromARGB(255, 68, 68, 68),
            borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Text(
          deviceVariable.getFormatedValue(),
          textAlign: TextAlign.end,
          style: TextStyle(color: Theme.of(context).colorScheme.primary),
        ),
      ),
    ));
  }

  List<Widget> getActionButtonsWidgets(
      DeviceVariableListingViewModel viewModel, BuildContext context) {
    var iconColor = Theme.of(context).colorScheme.primary;
    double iconSize = 20;
    return [
      IconButton(
          onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeviceVariableEditor(
                            settings: deviceVariable.settings,
                            validationCallback: (newSettings) =>
                                viewModel.setDeviceVariableSettings(
                                    deviceVariable, newSettings))))
              },
          icon: Icon(
            Icons.edit,
            color: iconColor,
            size: iconSize,
          )),
      IconButton(
          onPressed: () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DeviceVariableEditor(
                            settings: deviceVariable.settings,
                            validationCallback: (newSettings) => viewModel
                                .setDeviceVariableSettings(null, newSettings))))
              },
          icon: Icon(
            Icons.copy,
            color: iconColor,
            size: iconSize,
          )),
      IconButton(
          onPressed: () {
            viewModel.removeDeviceVariable(deviceVariable);
          },
          icon: Icon(
            Icons.delete,
            color: iconColor,
            size: iconSize,
          )),
    ];
  }

  Text getVarNameWidget() => Text(deviceVariable.settings.name);

  Widget getRegisterAddressWidget() =>
      Text(deviceVariable.settings.registerAddress.toString());

  Widget getDeviceVarialeStatusIndicator(
      DeviceVariable deviceVariable, BuildContext context) {
    var theme = Theme.of(context);
    String text = "unknow";
    Widget symbole = const Icon(Icons.help_outline);
    Color? textColor;

    switch (deviceVariable.state.value) {
      case DeviceVariableStatus.reading:
        text = "Reading";
        symbole = const CircularProgressIndicator();
      case DeviceVariableStatus.writing:
        text = "Wrinting";
        symbole = const CircularProgressIndicator();
      case DeviceVariableStatus.idle:
        if (deviceVariable.settings.isNotProperlyConfigured()) {
          text = "Not Properly configured";
          symbole = const Icon(Icons.warning_amber_rounded);
          textColor = const Color.fromARGB(255, 226, 175, 7);
        } else {
          switch (deviceVariable.lastResponseCode) {
            case null:
              text = "Unkown";
            case ModbusResponseCode.requestSucceed:
              text = "Ok";
              symbole = const Icon(Icons.check_circle_outline);
              textColor = const Color.fromARGB(255, 11, 219, 46);
            case _:
              text = deviceVariable.lastResponseCode!.name;
              symbole = const Icon(Icons.cancel_outlined);
              textColor = theme.colorScheme.error;
          }
        }
    }
    /*return Text.rich(TextSpan(children: [
      WidgetSpan(child: symbole),
      TextSpan(
        text: text,
        style: TextStyle(color: textColor),
      )
    ]));*/

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 20, width: 20, child: Center(child: symbole)),
        const Padding(padding: EdgeInsets.only(left: 10)),
        Text(
          text,
          style: TextStyle(color: textColor, overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }
}
