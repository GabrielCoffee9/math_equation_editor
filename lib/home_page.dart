import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart' show InputDecoration, OutlineInputBorder;
import 'package:math_equation_editor/widgets/export_flyout.dart';
import 'package:math_equation_editor/widgets/render_tex.dart';
import 'package:math_keyboard/math_keyboard.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool twoSides = false;
  String leftField = '';
  String rightField = '';
  List<String> leftVariables = [];
  List<String> rightVariables = [];
  @override
  Widget build(BuildContext context) {
    return NavigationView(
      content: ScaffoldPage(
        content: Column(
          children: <Widget>[
            Container(
              height: 120,
              width: 400,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: Colors.transparent),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Button(
                      onPressed: () {},
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
                        variables: const [],
                        keyboardType: MathKeyboardType.expression,
                        decoration: InputDecoration(
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
                      variables: const [],
                      keyboardType: MathKeyboardType.expression,
                      decoration: InputDecoration(
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
            Padding(
              padding: const EdgeInsets.only(top: 50.0),
              child: ToggleSwitch(
                content: Text(
                    twoSides ? 'Igualdade ativada' : 'Igualdade desativada'),
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
            ),
            const SizedBox(
              height: 40,
            ),
            Column(
              children: [
                const Text('Prévia:'),
                RenderTex(
                  textSource: (twoSides && rightField.isNotEmpty)
                      ? ('$leftField = $rightField')
                      : leftField,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
