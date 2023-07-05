// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:math_keyboard/math_keyboard.dart';

import '../widgets/copy_save_buttons.dart';
import '../widgets/render_tex.dart';
import 'exporter.dart';

class ExportSvgPage extends StatefulWidget {
  const ExportSvgPage({super.key, this.tex = ''});
  final String tex;

  @override
  State<ExportSvgPage> createState() => _ExportSvgPageState();
}

class _ExportSvgPageState extends State<ExportSvgPage> {
  String? tempTex;

  double scaleValue = 2.0;

  int red = 0;
  int green = 0;
  int blue = 0;

  var leftSubEditingController = MathFieldEditingController();
  var rightSubEditingController = MathFieldEditingController();
  var exporter = Exporter();

  @override
  void initState() {
    super.initState();
    tempTex = widget.tex;
  }

  @override
  Widget build(BuildContext context) {
    RenderTex renderTex = RenderTex(
      textSource: tempTex ?? '',
      red: red,
      green: green,
      blue: blue,
      scaleValue: scaleValue,
    );
    return ScaffoldPage(
      content: SingleChildScrollView(
        child: Column(
          children: [
            Expander(
              header: const Text(
                'Substituir caractere ou palavra antes de exportar',
              ),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 220,
                    child: MathField(
                      controller: leftSubEditingController,
                      authorizeAnyKey: true,
                      variables: const [],
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                    child: Text('>'),
                  ),
                  SizedBox(
                    width: 220,
                    child: MathField(
                      controller: rightSubEditingController,
                      authorizeAnyKey: true,
                      variables: const [],
                    ),
                  ),
                  FilledButton(
                    onPressed: () {
                      setState(() {
                        if (tempTex != null && tempTex!.isNotEmpty) {
                          tempTex = tempTex!.replaceAll(
                            leftSubEditingController.currentEditingValue(),
                            rightSubEditingController.currentEditingValue(),
                          );
                        }
                      });
                    },
                    child: const Text('Substituir'),
                  )
                ],
              ),
            ),
            Expander(
              header: const Text('Alterar escala e cor'),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Multiplicador de renderização:'),
                  Row(
                    children: [
                      SizedBox(
                        width: 180,
                        child: NumberBox(
                          min: 1,
                          max: 10,
                          onChanged: (value) {
                            setState(() {
                              scaleValue = value ?? 1.0;
                            });
                          },
                          value: scaleValue,
                          smallChange: 0.1,
                          mode: SpinButtonPlacementMode.inline,
                        ),
                      ),
                      Tooltip(
                        message:
                            'Define o tamanho da renderização dos caracteres, o padrão e recomendado é 2.0',
                        child: IconButton(
                          icon: const Icon(FluentIcons.help),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text('Cor em R.G.B:'),
                  Row(
                    children: [
                      SizedBox(
                        width: 80,
                        child: NumberBox(
                          placeholder: 'Red',
                          min: 0,
                          max: 255,
                          value: red,
                          mode: SpinButtonPlacementMode.none,
                          onChanged: (value) => setState(() {
                            red = value ?? 0;
                          }),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: NumberBox(
                          placeholder: 'Green',
                          min: 0,
                          max: 255,
                          value: green,
                          mode: SpinButtonPlacementMode.none,
                          onChanged: (value) => setState(() {
                            green = value ?? 0;
                          }),
                        ),
                      ),
                      SizedBox(
                        width: 80,
                        child: NumberBox(
                          placeholder: 'Blue',
                          min: 0,
                          max: 255,
                          value: blue,
                          mode: SpinButtonPlacementMode.none,
                          onChanged: (value) => setState(() {
                            blue = value ?? 0;
                          }),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
            const Text('Prévia:'),
            Padding(
              padding: const EdgeInsets.only(top: 50.0, bottom: 120),
              child: renderTex,
            ),
          ],
        ),
      ),
      bottomBar: CopySaveButtons(
        copyOnPressed: () async {
          try {
            exporter.copySVG(
              tempTex ?? widget.tex,
              scaleValue: renderTex.scaleValue,
              red: red,
              green: green,
              blue: blue,
            );

            exporter.displayExportResult(
              context,
              'Copiado!',
              'Conteúdo SVG copiado para a área de transferência',
            );
          } catch (e) {
            exporter.displayExportResult(
                context, 'Erro', 'Descrição : $e', false);
          }
        },
        saveOnPressed: () async {
          try {
            var result = await exporter.saveSVG(
              tempTex ?? widget.tex,
              scaleValue: renderTex.scaleValue,
              red: red,
              green: green,
              blue: blue,
            );
            if (result) {
              exporter.displayExportResult(
                context,
                'Salvo!',
                'O arquivo SVG foi salvo no local escolhido',
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
