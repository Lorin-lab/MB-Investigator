import 'package:flutter/material.dart';
import 'package:mb_investigator/ui/var_writing_dialogue/var_writing_dialogque_viewmodel.dart';

class VarWritingDialogueScreen {
  static Future<void> show(
      BuildContext context, final VarWritingDialogueViewModel viewModel) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(viewModel.varName),
          content: ListenableBuilder(
              listenable: viewModel,
              builder: (context, _) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        "Type: ${viewModel.varEcoding} (${viewModel.vardataUnitCount} word/bit)"),
                    const Padding(padding: EdgeInsets.only(top: 30)),
                    Row(
                      children: [
                        SizedBox(
                          width: 300,
                          child: TextFormField(
                            autofocus: true,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              error: () {
                                if (viewModel.encodingError == null) {
                                  return null;
                                }
                                return Tooltip(
                                  message: viewModel.encodingErrorDetail,
                                  child: Text(
                                    viewModel.encodingError ?? "",
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .error),
                                  ),
                                );
                              }(),
                              icon: const Icon(Icons.edit),
                              fillColor: const Color.fromARGB(255, 68, 68, 68),
                              filled: true,
                              border: const OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))),
                            ),
                            onChanged: viewModel.onNewValueEdit,
                            initialValue: viewModel.newValue,
                          ),
                        ),
                      ],
                    ),
                    Text("Final encoded data: ${viewModel.finalEncodedData}"),
                    Text("Final encoded value: ${viewModel.finalEncodedDValue}")
                  ],
                );
              }),
          actions: <Widget>[
            ListenableBuilder(
                listenable: viewModel,
                builder: (context, _) {
                  return TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    onPressed: (viewModel.finalEncodedData == null)
                        ? null
                        : () => viewModel.cmdWrite(context),
                    child: const Text('Write'),
                  );
                }),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
