import 'package:flutter/material.dart';
import 'package:mb_investigator/domain/models/device_variable_settings.dart';
import 'package:mb_investigator/ui/core/dialogue_builders.dart';
import 'package:mb_investigator/ui/device_variable_listing/device_variable_card.dart';
import 'package:mb_investigator/ui/device_variable_listing/device_variable_listing_viewmodel.dart';
import 'package:mb_investigator/ui/remote_device_editor/remote_device_editor.dart';
import 'package:mb_investigator/ui/device_variable_editor/device_variable_editor.dart';
import 'package:mb_investigator/ui/about/app_about.dart';
import 'package:provider/provider.dart';

class DeviceVariableListingScreen extends StatefulWidget {
  const DeviceVariableListingScreen({super.key});

  @override
  State<DeviceVariableListingScreen> createState() =>
      _DeviceVariableListingScreenState();
}

class _DeviceVariableListingScreenState
    extends State<DeviceVariableListingScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DeviceVariableListingViewModel>(builder:
        (BuildContext context, DeviceVariableListingViewModel viewModel,
            Widget? child) {
      return Scaffold(
        appBar: AppBar(
          leading: PopupMenuButton(
              icon: const Icon(Icons.more_vert),
              itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                    PopupMenuItem(
                      child: const ListTile(
                          leading: Icon(Icons.download), title: Text("Import")),
                      onTap: () async {
                        try {
                          await viewModel.importConfig();
                        } on FormatException catch (ex) {
                          DialogueBuilders.showExecptionDialog(context,
                              "Unsupported data format", ex.message, ex);
                        } catch (ex) {
                          DialogueBuilders.showExecptionDialog(
                              context,
                              "Import failed",
                              "Configuration import failed for unknown reason.",
                              ex);
                        }
                      },
                    ),
                    PopupMenuItem(
                      child: const ListTile(
                          leading: Icon(Icons.upload), title: Text("Export")),
                      onTap: () async {
                        try {
                          await viewModel.expotrConfig();
                        } catch (ex) {
                          DialogueBuilders.showExecptionDialog(
                              context,
                              "Export failed",
                              "Configuration export failed for unknown reason.",
                              ex);
                        }
                      },
                    ),
                    PopupMenuItem(
                      child: const ListTile(
                          leading: Icon(Icons.info), title: Text("About")),
                      onTap: () => AppAbout.showAbout(context),
                    ),
                  ]),
          title: TextButton.icon(
            label: Text(viewModel.getClientName()),
            icon: const Icon(Icons.edit),
            onPressed: () => {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RemoteDeviceEditor(
                          viewModel.getRemoteDeviceSettings()))),
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Card(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                      tooltip: "Read all",
                      onPressed: viewModel.isAbleToReading()
                          ? null
                          : viewModel.startReading,
                      icon: const Icon(Icons.play_circle)),
                  IconButton(
                      tooltip: "Stop reading",
                      onPressed: viewModel.isAbleToStop()
                          ? viewModel.stopReading
                          : null,
                      icon: const Icon(Icons.stop_circle)),
                  Tooltip(
                    message: "Toggle periodic reading",
                    child: Switch(
                        value: viewModel.reapeatReading,
                        onChanged: (bool v) {
                          setState(() {
                            viewModel.reapeatReading = v;
                          });
                        },
                        thumbIcon: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return const Icon(
                              Icons.repeat,
                              color: Colors.white,
                            );
                          } else {
                            return const Icon(Icons.repeat);
                          }
                        })),
                  ),
                ],
              )),
              Expanded(
                child: ReorderableListView.builder(
                    itemCount: viewModel.getDeviceVariables().length,
                    itemBuilder: (context, index) {
                      var deviceVariable =
                          viewModel.getDeviceVariables()[index];
                      var card = DeviceVariableCard(
                          key: ValueKey(index), deviceVariable: deviceVariable);
                      return card;
                    },
                    onReorder: viewModel.reorderDeviceVariableList),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DeviceVariableEditor(
                        settings: DeviceVariableSettings(),
                        validationCallback: (newSettings) => viewModel
                            .setDeviceVariableSettings(null, newSettings)))),
          },
          tooltip: 'Add Element',
          child: const Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      );
    });
  }
}
