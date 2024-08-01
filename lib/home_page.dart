import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration, OutlineInputBorder;
import 'package:math_keyboard/math_keyboard.dart';

import 'export/exporter.dart';
import 'import/importer.dart';
import 'widgets/context_menu.dart';
import 'widgets/export_flyout.dart';
import 'widgets/render_tex.dart';

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

  ValueNotifier<bool> twoSides = ValueNotifier(true);

  var importer = Importer();

  @override
  void dispose() {
    leftController.dispose();
    rightController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    twoSides.addListener(() {
      setState(() {
        if (twoSides.value) {
          if (rightController.alreadyDisposed) {
            rightController = MathFieldEditingController();
          }
        } else {
          rightField = '';
          rightController.dispose();
        }
      });
    });
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
                          onPressed: () async {
                            try {
                              var importerResult =
                                  await importer.importEquation();
                              setState(() {
                                leftController.rootFromJson(importerResult.$1);
                                leftField =
                                    leftController.currentEditingValue();

                                if (importerResult.$2 != null) {
                                  twoSides.value = true;

                                  rightController
                                      .rootFromJson(importerResult.$2!);
                                  rightField =
                                      rightController.currentEditingValue();
                                } else {
                                  twoSides.value = false;
                                  rightField = '';
                                }
                              });
                            } catch (e) {
                              //
                            }
                          },
                          child: const Text('Importar equação'),
                        ),
                        ExportFlyout(
                          tex: (twoSides.value && rightField.isNotEmpty)
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
                            authorizeAnyKey: true,
                            variables: const [],
                            keyboardType: MathKeyboardType.expression,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                ),
                              ),
                              hintText: twoSides.value
                                  ? 'Lado esquerdo da equação'
                                  : 'Equação',
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
                      visible: twoSides.value,
                      child: const Padding(
                        padding: EdgeInsets.only(left: 8.0, right: 8.0),
                        child: Text(
                          '=',
                          style: TextStyle(fontSize: 30),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: twoSides.value,
                      child: SizedBox(
                        width: 350,
                        child: MathField(
                          controller: rightController,
                          authorizeAnyKey: true,
                          variables: const [],
                          keyboardType: MathKeyboardType.expression,
                          decoration: InputDecoration(
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                            hintText: twoSides.value
                                ? 'Lado direito da equação'
                                : 'Equação',
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
                  content: Text(twoSides.value
                      ? 'Igualdade ativada'
                      : 'Igualdade desativada'),
                  checked: twoSides.value,
                  onChanged: (value) {
                    twoSides.value = value;
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
                            label: const Text('Compartilhar'),
                            onPressed: () {
                              Exporter().saveTex(
                                (twoSides.value && rightField.isNotEmpty)
                                    ? '${leftController.rootToJson()} ?=? ${rightController.rootToJson()}'
                                    : leftController.rootToJson(),
                                defaultExt: 'json',
                              );
                            },
                          ),
                          CommandBarButton(
                            icon: const Icon(FluentIcons.delete),
                            label: const Text('Limpar'),
                            onPressed: () {
                              leftController.clear();
                              if (!rightController.alreadyDisposed) {
                                rightController.clear();
                              }
                              leftField = '';
                              rightField = '';

                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                          ),
                        ],
                        child: RenderTex(
                          textSource: (twoSides.value && rightField.isNotEmpty)
                              ? ('$leftField = $rightField')
                              : leftField,
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
            )
          ],
        ),
      ),
    );
  }
}
