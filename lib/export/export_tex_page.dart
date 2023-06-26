import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/services.dart';
import 'package:math_equation_editor/export/exporter.dart';

class ExportTexPage extends StatefulWidget {
  const ExportTexPage({super.key, this.tex = ''});
  final String tex;

  @override
  State<ExportTexPage> createState() => _ExportTexPageState();
}

class _ExportTexPageState extends State<ExportTexPage> {
  String? tempTex;
  TextEditingController leftSubEditingController = TextEditingController();
  TextEditingController rightSubEditingController = TextEditingController();

  Exporter exporter = Exporter();

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
                              rightSubEditingController.text);
                        }
                      });
                    })
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 60.0, bottom: 15.0),
            child: Text('Prévia:'),
          ),
          SelectableText(
            tempTex ?? widget.tex,
            style: const TextStyle(fontSize: 24.0),
          ),
          const SizedBox(
            height: 1e2,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              FilledButton(
                child: const Text('Copiar'),
                onPressed: () async {
                  try {
                    await Clipboard.setData(
                      ClipboardData(text: tempTex ?? widget.tex),
                    );
                    // ignore: use_build_context_synchronously
                    if (!context.mounted) return;
                    displayInfoBar(context, builder: (context, close) {
                      return InfoBar(
                        title: const Text('Copiado!'),
                        content: const Text(
                          'Conteúdo TeX copiado para a área de transferência',
                        ),
                        action: IconButton(
                          icon: const Icon(FluentIcons.clear),
                          onPressed: close,
                        ),
                        severity: InfoBarSeverity.success,
                      );
                    });
                    Navigator.of(context).pop();
                  } catch (e) {
                    //
                  }
                },
              ),
              FilledButton(
                  child: const Text('Salvar'),
                  onPressed: () async {
                    var _result = await exporter.saveTex(tempTex ?? widget.tex);
                    if (_result) {
                      // ignore: use_build_context_synchronously
                      if (!context.mounted) return;
                      displayInfoBar(context, builder: (context, close) {
                        return InfoBar(
                          title: const Text('Salvo!'),
                          content: const Text(
                            'Conteúdo TeX foi salvo no local escolhido',
                          ),
                          action: IconButton(
                            icon: const Icon(FluentIcons.clear),
                            onPressed: close,
                          ),
                          severity: InfoBarSeverity.success,
                        );
                      });
                      Navigator.of(context).pop();
                    }
                  }),
            ],
          )
        ],
      ),
    );
  }
}
