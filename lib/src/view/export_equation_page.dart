// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration, OutlineInputBorder;
import 'package:math_keyboard/math_keyboard.dart';

import '../view_model/equation_view_model.dart';
import 'widgets/copy_save_buttons.dart';
import 'widgets/info_popup.dart';
import 'widgets/render_tex.dart';
import 'widgets/widget_to_image.dart';
import '../model/exporter.dart';

class ExportEquationPage extends StatefulWidget {
  const ExportEquationPage({super.key, required this.tex});
  final String tex;

  @override
  State<ExportEquationPage> createState() => _ExportEquationPageState();
}

class _ExportEquationPageState extends State<ExportEquationPage> {
  String? tempTex;

  ValueNotifier<String> extension = ValueNotifier('png');

  double scaleValue = 2.0;

  late final EquationViewModel equationViewModel;

  int red = 0;
  int green = 0;
  int blue = 0;

  bool hideEmptyBoxes = false;

  var leftSubEditingController = MathFieldEditingController();
  var rightSubEditingController = MathFieldEditingController();

  var exporter = Exporter();
  var imageKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    equationViewModel = EquationViewModel();
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
      keepEmptyBoxes: !hideEmptyBoxes,
    );
    return ScaffoldPage(
      content: SingleChildScrollView(
        child: Column(
          children: [
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
                          highlightColor: Colors.black,
                          mode: SpinButtonPlacementMode.inline,
                          onChanged: (value) => setState(() {
                            scaleValue = value ?? 1;
                          }),
                        ),
                      ),
                      Tooltip(
                        message:
                            'Define o tamanho da imagem ou vetor que será exportado (não afeta textos)',
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
                          highlightColor: Colors.black,
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
                          highlightColor: Colors.black,
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
                          highlightColor: Colors.black,
                          mode: SpinButtonPlacementMode.none,
                          onChanged: (value) => setState(() {
                            blue = value ?? 0;
                          }),
                        ),
                      ),
                      Tooltip(
                        message:
                            'Define a cor da imagem ou vetor que será exportado (não afeta textos)',
                        child: IconButton(
                          icon: const Icon(FluentIcons.help),
                          onPressed: () {},
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expander(
              header: const Text(
                  'Substituir caractere ou palavra antes de exportar'),
              content: Row(
                children: [
                  SizedBox(
                    width: 220,
                    child: MathField(
                      controller: leftSubEditingController,
                      authorizeAnyKey: true,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(150, 50, 49, 48),
                          ),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Expressão atual',
                      ),
                      variables: const [],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Icon(FluentIcons.page_arrow_right),
                  ),
                  SizedBox(
                    width: 220,
                    child: MathField(
                      controller: rightSubEditingController,
                      authorizeAnyKey: true,
                      decoration: const InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Color.fromARGB(150, 50, 49, 48),
                          ),
                        ),
                        border: OutlineInputBorder(),
                        hintText: 'Expressão substituta',
                      ),
                      variables: const [],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: FilledButton(
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
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Checkbox(
                    checked: hideEmptyBoxes,
                    content: const Text(
                      'Ocultar espaços vazios em exportações gráficas',
                    ),
                    onChanged: (value) {
                      setState(() {
                        hideEmptyBoxes = value!;
                      });
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  const Text('Extensão do arquivo de exportação:'),
                  const SizedBox(width: 10),
                  DropDownButton(
                    title: ListenableBuilder(
                      listenable: extension,
                      builder: (context, child) =>
                          Text(extension.value.toUpperCase()),
                    ),
                    items: [
                      MenuFlyoutItem(
                        text: const Text('PNG'),
                        onPressed: () => setState(() {
                          extension.value = 'png';
                        }),
                      ),
                      MenuFlyoutItem(
                        text: const Text('JPEG'),
                        onPressed: () => setState(() {
                          extension.value = 'jpeg';
                        }),
                      ),
                      MenuFlyoutItem(
                        text: const Text('SVG'),
                        onPressed: () => setState(() {
                          extension.value = 'svg';
                        }),
                      ),
                      const MenuFlyoutSeparator(),
                      MenuFlyoutItem(
                        text: const Text('PDF'),
                        onPressed: () => setState(() {
                          extension.value = 'pdf';
                        }),
                      ),
                      MenuFlyoutItem(
                        text: const Text('TeX'),
                        onPressed: () => setState(() {
                          extension.value = 'tex';
                        }),
                      ),
                      MenuFlyoutItem(
                        text: const Text('Texto'),
                        onPressed: () => setState(() {
                          extension.value = 'text';
                        }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 30.0, bottom: 15.0),
              child: Text('Prévia:'),
            ),
            SingleChildScrollView(
              child: SizedBox(
                child: Builder(
                  builder: (context) {
                    if (extension.value == 'text') {
                      return SelectableText(
                        style: const TextStyle(fontSize: 30),
                        equationViewModel.texToText(tempTex ?? widget.tex),
                      );
                    }

                    if (extension.value == 'tex') {
                      return SelectableText(
                        style: const TextStyle(fontSize: 30),
                        tempTex ?? widget.tex,
                      );
                    }

                    return WidgetToImage(
                      key: imageKey,
                      targetWidget: renderTex,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      bottomBar: CopySaveButtons(
        copyOnPressed: () async {
          try {
            if (!mounted) return;

            var result = await equationViewModel.copyEquationClipboard(
              targetWidgetKey: imageKey,
              tex: tempTex ?? widget.tex,
              extensionKey: extension.value,
              scale: scaleValue,
              red: red,
              green: green,
              blue: blue,
              keepEmptyBoxes: !hideEmptyBoxes,
            );

            if (result) {
              _displayExportResult(
                context,
                'Copiado!',
                'Equação copiada para a área de transferência como ${extension.value.toUpperCase()}',
              );
            }
          } catch (e) {
            _displayExportResult(
              context,
              'Erro',
              'Descrição : $e',
              success: false,
            );
          }
        },
        saveOnPressed: () async {
          try {
            if (!mounted) return;

            var result = await equationViewModel.exportEquation(
              targetWidgetKey: imageKey,
              tex: tempTex ?? widget.tex,
              extensionKey: extension.value,
              scale: scaleValue,
              red: red,
              green: green,
              blue: blue,
              keepEmptyBoxes: !hideEmptyBoxes,
            );

            if (result) {
              _displayExportResult(
                context,
                'Salvo!',
                'A imagem foi salva no local escolhido',
              );
            }
          } catch (e) {
            _displayExportResult(
              context,
              'Erro',
              'Descrição : $e',
              success: false,
            );
          }
        },
      ),
    );
  }
}

void _displayExportResult(BuildContext context, String title, String info,
    {bool success = true}) {
  displayInfoBar(
    context,
    builder: (context, close) => InfoPopUp(
      title: title,
      content: Text(info),
      close: close,
      type: success ? InfoBarSeverity.success : InfoBarSeverity.error,
    ),
  );
  if (success) {
    Navigator.of(context).pop();
  }
}
