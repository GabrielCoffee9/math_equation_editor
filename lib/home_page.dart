import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration, OutlineInputBorder;
import 'package:math_equation_editor/export/exporter.dart';
import 'package:math_equation_editor/import/importer.dart';
import 'package:math_equation_editor/widgets/context_menu.dart';
import 'package:math_equation_editor/widgets/export_flyout.dart';
import 'package:math_equation_editor/widgets/render_tex.dart';
import 'package:math_keyboard/math_keyboard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var leftController = MathFieldEditingController();
  var rightController = MathFieldEditingController();

  String leftField = '';
  String rightField = '';

  bool twoSides = false;

  var importer = Importer();
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage(
        content: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(left: 8.0, right: 8.0),
              child: RenderTex(
                textSource:
                    r'\frac{\Mu ath \sum quation \sum ditor}{\alpha lpha}',
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
                      onPressed: () async {
                        var importerResult = await importer.importEquation();
                        setState(() {
                          leftController.rootFromJson(importerResult.$1);

                          leftField = leftController.currentEditingValue();

                          if (importerResult.$2 != null) {
                            rightController.rootFromJson(importerResult.$2!);
                            rightField = rightController.currentEditingValue();
                            twoSides = true;
                          } else {
                            twoSides = false;
                            rightController.clear();
                            rightField = '';
                          }
                        });
                      },
                      child: const Text('Importar equação'),
                    ),
                    ExportFlyout(
                      tex: (twoSides && rightField.isNotEmpty)
                          ? ('$leftField = $rightField')
                          : leftField,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    SizedBox(
                      width: 350,
                      child: MathField(
                        controller: leftController,
                        variables: const [],
                        keyboardType: MathKeyboardType.expression,
                        decoration: InputDecoration(
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                            ),
                          ),
                          hintText:
                              twoSides ? 'Lado esquerdo da equação' : 'Equação',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            leftField = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                Visibility(
                  visible: twoSides,
                  child: const Padding(
                    padding: EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Text(
                      '=',
                      style: TextStyle(fontSize: 30),
                    ),
                  ),
                ),
                Visibility(
                  visible: twoSides,
                  child: SizedBox(
                    width: 350,
                    child: MathField(
                      controller: rightController,
                      variables: const [],
                      keyboardType: MathKeyboardType.expression,
                      decoration: InputDecoration(
                        focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.black,
                          ),
                        ),
                        hintText:
                            twoSides ? 'Lado direito da equação' : 'Equação',
                        border: const OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() {
                          rightField = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            ToggleSwitch(
              content:
                  Text(twoSides ? 'Igualdade ativada' : 'Igualdade desativada'),
              checked: twoSides,
              onChanged: (value) {
                setState(() {
                  twoSides = value;
                  if (!twoSides) {
                    rightField = '';
                  }
                });
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: Column(
                children: [
                  const Text('Prévia:'),
                  const SizedBox(height: 20.0),
                  ContextMenu(
                    primaryItems: [
                      CommandBarButton(
                        icon: const Icon(FluentIcons.share),
                        label: const Text('Share'),
                        onPressed: () {
                          Exporter().saveTex(
                              '${leftController.rootToJson()} = ${rightController.rootToJson()}');
                        },
                      ),
                      CommandBarButton(
                        icon: const Icon(FluentIcons.copy),
                        label: const Text('Copy'),
                        onPressed: () {},
                      ),
                      CommandBarButton(
                        icon: const Icon(FluentIcons.delete),
                        label: const Text('Clear'),
                        onPressed: () {},
                      ),
                    ],
                    child: RenderTex(
                      textSource: (twoSides && rightField.isNotEmpty)
                          ? ('$leftField = $rightField')
                          : leftField,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
