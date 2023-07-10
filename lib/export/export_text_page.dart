// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

import '../widgets/copy_save_buttons.dart';
import 'exporter.dart';

class ExportTextPage extends StatefulWidget {
  const ExportTextPage({super.key, this.text = ''});
  final String text;

  @override
  State<ExportTextPage> createState() => _ExportTextPageState();
}

class _ExportTextPageState extends State<ExportTextPage> {
  String? tempText;
  String? originalText;

  var leftSubEditingController = TextEditingController();
  var rightSubEditingController = TextEditingController();

  var exporter = Exporter();

  @override
  void initState() {
    super.initState();
    originalText = exporter.texToText(widget.text);
    tempText = originalText;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Expander(
              header: const Text(
                  'Substituir caractere ou palavra antes de exportar'),
              content: Row(
                children: [
                  SizedBox(
                    width: 220,
                    child: TextBox(
                      controller: leftSubEditingController,
                      placeholder: '',
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text('>'),
                  ),
                  SizedBox(
                    width: 220,
                    child: TextBox(
                      controller: rightSubEditingController,
                      placeholder: '',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FilledButton(
                        child: const Text('Substituir'),
                        onPressed: () {
                          setState(() {
                            if (tempText != null && tempText!.isNotEmpty) {
                              tempText = tempText!.replaceAll(
                                  leftSubEditingController.text,
                                  rightSubEditingController.text);
                            }
                          });
                        }),
                  )
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 60.0, bottom: 15.0),
              child: Text('Prévia:'),
            ),
            SelectableText(
              tempText ?? widget.text,
              style: const TextStyle(fontSize: 50.0),
            ),
          ],
        ),
      ),
      bottomBar: CopySaveButtons(
        copyOnPressed: () async {
          try {
            await Clipboard.setData(
              ClipboardData(text: tempText ?? widget.text),
            );
            exporter.displayExportResult(
              context,
              'Copiado!',
              'Texto copiado para a área de transferência',
            );
          } catch (e) {
            exporter.displayExportResult(
                context, 'Erro', 'Descrição : $e', false);
          }
        },
        saveOnPressed: () async {
          try {
            var result = await exporter.saveTex(tempText ?? widget.text,
                defaultExt: 'txt');
            if (result) {
              exporter.displayExportResult(
                context,
                'Salvo!',
                'O texto foi salvo no local escolhido',
              );
            }
          } catch (e) {
            exporter.displayExportResult(
                context, 'Erro', 'Descrição : $e', false);
          }
        },
      ),
    );
  }
}
