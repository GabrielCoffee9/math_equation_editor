// ignore_for_file: use_build_context_synchronously

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration, OutlineInputBorder;
import 'package:math_keyboard/math_keyboard.dart';

import '../view_model/equation_view_model.dart';
import 'export_equation_page.dart';
import 'widgets/info_popup.dart';
import 'widgets/render_tex.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final EquationViewModel equationViewModel;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    equationViewModel = EquationViewModel();
  }

  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage(
        content: ListView(
          children: [
            Column(
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  child: RenderTex(
                    textSource:
                        r'\frac{\Mu ath \sum quation \sum ditor}{\beta eta}',
                    scaleValue: 3,
                  ),
                ),
                Container(
                  height: 70,
                  width: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18),
                    color: Colors.transparent,
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Button(
                          onPressed: () {
                            equationViewModel.importEquation();
                          },
                          child: const Text('Importar equação'),
                        ),
                        Button(
                          child: const Text('Exportar equação'),
                          onPressed: () async {
                            await showDialog<String>(
                              dismissWithEsc: true,
                              barrierDismissible: true,
                              context: context,
                              builder: (context) => ContentDialog(
                                constraints: const BoxConstraints(
                                  maxWidth: 1024,
                                  maxHeight: 650,
                                ),
                                title: const Text('Exportar Equação'),
                                content: ExportEquationPage(
                                  tex: (equationViewModel
                                              .twoExpressions.value &&
                                          equationViewModel
                                              .leftExpressionEditing
                                              .currentEditingValue()
                                              .isNotEmpty)
                                      ? ('${equationViewModel.leftExpressionEditing.currentEditingValue(
                                          placeholderWhenEmpty: false,
                                        )} = ${equationViewModel.rightExpressionEditing.currentEditingValue(
                                          placeholderWhenEmpty: false,
                                        )}')
                                      : equationViewModel.leftExpressionEditing
                                          .currentEditingValue(
                                          placeholderWhenEmpty: false,
                                        ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ListenableBuilder(
                  listenable: equationViewModel,
                  builder: (context, child) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              width: 350,
                              child: MathField(
                                controller:
                                    equationViewModel.leftExpressionEditing,
                                authorizeAnyKey: true,
                                variables: const [],
                                keyboardType: MathKeyboardType.expression,
                                decoration: InputDecoration(
                                  focusedBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  enabledBorder: const OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Color.fromARGB(150, 50, 49, 48),
                                    ),
                                  ),
                                  hintText:
                                      equationViewModel.twoExpressions.value
                                          ? 'Expressão da esquerda'
                                          : 'Equação',
                                  border: const OutlineInputBorder(),
                                ),
                                onChanged: (value) => setState(() {}),
                              ),
                            ),
                          ],
                        ),
                        Visibility(
                          visible: equationViewModel.twoExpressions.value,
                          child: const Padding(
                            padding: EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Text(
                              '=',
                              style: TextStyle(fontSize: 30),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: equationViewModel.twoExpressions.value,
                          child: SizedBox(
                            width: 350,
                            child: MathField(
                              controller:
                                  equationViewModel.rightExpressionEditing,
                              authorizeAnyKey: true,
                              variables: const [],
                              keyboardType: MathKeyboardType.expression,
                              decoration: InputDecoration(
                                focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.black,
                                  ),
                                ),
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Color.fromARGB(150, 50, 49, 48),
                                  ),
                                ),
                                hintText: equationViewModel.twoExpressions.value
                                    ? 'Expressão da direita'
                                    : 'Equação',
                                border: const OutlineInputBorder(),
                              ),
                              onChanged: (value) => setState(() {}),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(height: 40),
                ToggleButton(
                  checked: equationViewModel.twoExpressions.value,
                  onChanged: (value) {
                    setState(() {
                      equationViewModel.twoExpressions.value = value;
                    });
                  },
                  child: Text(equationViewModel.twoExpressions.value
                      ? 'Uma expressão'
                      : 'Duas expressões'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: Column(
                    children: [
                      const Text('Prévia:'),
                      const SizedBox(height: 15.0),
                      RenderTex(
                        textSource: (equationViewModel.twoExpressions.value &&
                                equationViewModel.rightExpressionEditing
                                    .currentEditingValue(
                                        placeholderWhenEmpty: false)
                                    .isNotEmpty)
                            ? ('${equationViewModel.leftExpressionEditing.currentEditingValue(
                                placeholderWhenEmpty: false,
                              )} = ${equationViewModel.rightExpressionEditing.currentEditingValue(
                                placeholderWhenEmpty: false,
                              )}')
                            : equationViewModel.leftExpressionEditing
                                .currentEditingValue(
                                placeholderWhenEmpty: false,
                              ),
                      ),
                      const SizedBox(height: 30.0),
                      Visibility(
                        visible: (equationViewModel.leftExpressionEditing
                                .currentEditingValue(
                                    placeholderWhenEmpty: false)
                                .isNotEmpty ||
                            equationViewModel.rightExpressionEditing
                                .currentEditingValue(
                                    placeholderWhenEmpty: false)
                                .isNotEmpty),
                        child: CommandBar(
                          mainAxisAlignment: MainAxisAlignment.center,
                          overflowBehavior: CommandBarOverflowBehavior.noWrap,
                          primaryItems: [
                            CommandBarBuilderItem(
                              builder: (context, mode, w) => Tooltip(
                                message: "Limpa a equação atual",
                                child: w,
                              ),
                              wrappedItem: CommandBarButton(
                                icon: const Icon(FluentIcons.delete),
                                label: const Text('Limpar'),
                                onPressed: () {
                                  equationViewModel.leftExpressionEditing
                                      .clear();
                                  equationViewModel.rightExpressionEditing
                                      .clear();
                                },
                              ),
                            ),
                            CommandBarBuilderItem(
                              builder: (context, mode, w) => Tooltip(
                                message:
                                    "Compartilhe essa equação com outra pessoa que utiliza o Math Equation Editor!",
                                child: w,
                              ),
                              wrappedItem: CommandBarButton(
                                icon: const Icon(FluentIcons.share),
                                label: const Text('Compartilhar'),
                                onPressed: () async {
                                  try {
                                    if (!mounted) return;

                                    var result =
                                        await equationViewModel.shareEquation();

                                    if (result) {
                                      _displayExportResult(
                                        context,
                                        'Compartilhada!',
                                        'Equação exportada para o local escolhido.',
                                      );
                                    }
                                  } catch (e) {
                                    _displayExportResult(
                                      context,
                                      'Erro',
                                      'Descrição: $e',
                                      success: false,
                                    );
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height < 1000
                  ? MediaQuery.of(context).size.height / 1.9
                  : 0,
            ),
          ],
        ),
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
}
