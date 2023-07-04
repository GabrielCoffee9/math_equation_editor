// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration, OutlineInputBorder;
import 'package:math_keyboard/math_keyboard.dart';

import '../widgets/copy_save_buttons.dart';
import '../widgets/render_tex.dart';
import '../widgets/widget_to_image.dart';
import 'exporter.dart';

class ExportPngPage extends StatefulWidget {
  const ExportPngPage({super.key, this.tex = ''});
  final String tex;

  @override
  State<ExportPngPage> createState() => _ExportPngPageState();
}

class _ExportPngPageState extends State<ExportPngPage> {
  String? tempTex;

  double scaleValue = 2.0;

  int red = 0;
  int green = 0;
  int blue = 0;

  var leftSubEditingController = MathFieldEditingController();
  var rightSubEditingController = MathFieldEditingController();

  var exporter = Exporter();
  var pngKey = GlobalKey();

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
                  'Substituir caractere ou palavra antes de exportar'),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 220,
                    child: MathField(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      variables: const [],
                      controller: leftSubEditingController,
                    ),
                  ),
                  const SizedBox(width: 10, child: Text('>')),
                  SizedBox(
                    width: 220,
                    child: MathField(
                      variables: const [],
                      controller: rightSubEditingController,
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
              header: const Text('Alterar resolução e cor'),
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
                          value: scaleValue,
                          smallChange: 0.1,
                          mode: SpinButtonPlacementMode.inline,
                          onChanged: (value) => setState(() {
                            scaleValue = value ?? 1;
                          }),
                        ),
                      ),
                      Tooltip(
                        message: 'Define o tamanho da imagem final',
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
            const Padding(
              padding: EdgeInsets.only(top: 60.0, bottom: 15.0),
              child: Text('Prévia:'),
            ),
            WidgetToImage(
              key: pngKey,
              targetWidget: renderTex,
            ),
          ],
        ),
      ),
      bottomBar: CopySaveButtons(
        copyOnPressed: () async {
          try {
            var result = await exporter.copyWidgetAsImage(
              context,
              pngKey,
              pixelRatio: renderTex.scaleValue,
            );

            if (result) {
              exporter.displayExportResult(
                context,
                'Copiado!',
                'PNG copiado para a área de transferência',
              );
            }
          } catch (e) {
            exporter.displayExportResult(
                context, 'Erro', 'Descrição : $e', false);
          }
        },
        saveOnPressed: () async {
          try {
            var result = await exporter.saveWidgetAsImage(
              context,
              pngKey,
              pixelRatio: renderTex.scaleValue,
            );

            if (result) {
              exporter.displayExportResult(
                context,
                'Salvo!',
                'O PNG foi salvo no local escolhido',
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
