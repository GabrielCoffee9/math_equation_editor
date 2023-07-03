// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';

import '../widgets/copy_save_buttons.dart';
import 'exporter.dart';

class ExportTexPage extends StatefulWidget {
  const ExportTexPage({super.key, this.tex = ''});
  final String tex;

  @override
  State<ExportTexPage> createState() => _ExportTexPageState();
}

class _ExportTexPageState extends State<ExportTexPage> {
  String? tempTex;

  var leftSubEditingController = TextEditingController();
  var rightSubEditingController = TextEditingController();

  var exporter = Exporter();

  @override
  void initState() {
    super.initState();
    tempTex = widget.tex;
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldPage(
      content: Column(
        children: [
          Expander(
            header:
                const Text('Substituir caractere ou palavra antes de exportar'),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 220,
                  child: TextBox(
                    controller: leftSubEditingController,
                    placeholder: '',
                  ),
                ),
                const SizedBox(
                  width: 10,
                  child: Text('>'),
                ),
                SizedBox(
                  width: 220,
                  child: TextBox(
                    controller: rightSubEditingController,
                    placeholder: '',
                  ),
                ),
                FilledButton(
                  child: const Text('Substituir'),
                  onPressed: () {
                    setState(() {
                      if (tempTex != null && tempTex!.isNotEmpty) {
                        tempTex = tempTex!.replaceAll(
                          leftSubEditingController.text,
                          rightSubEditingController.text,
                        );
                      }
                    });
                  },
                )
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 60.0, bottom: 15.0),
            child: Text('Prévia:'),
          ),
          SelectableText(
            tempTex ?? widget.tex,
            style: const TextStyle(fontSize: 50.0),
          ),
        ],
      ),
      bottomBar: CopySaveButtons(
        copyOnPressed: () async {
          try {
            await Clipboard.setData(
              ClipboardData(text: tempTex ?? widget.tex),
            );

            exporter.displayExportResult(
              context,
              'Copiado!',
              'Conteúdo TeX copiado para a área de transferência',
            );
          } catch (e) {
            exporter.displayExportResult(
                context, 'Erro', 'Descrição : $e', false);
          }
        },
        saveOnPressed: () async {
          try {
            var result = await exporter.saveTex(tempTex ?? widget.tex);
            if (result) {
              exporter.displayExportResult(
                context,
                'Salvo!',
                'Conteúdo TeX foi salvo no local escolhido',
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
