import 'package:flutter/material.dart';
import 'package:tex/tex.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RenderTex extends StatelessWidget {
  const RenderTex({super.key, this.textSource = ''});

  final String textSource;

  String _replaceUncompatibleTex(String textSource) => textSource
      .replaceAll(r'\Alpha', ' A ')
      .replaceAll(r'\Beta', ' B ')
      .replaceAll(r'\Epsilon', ' E ')
      .replaceAll(r'\Zeta', ' Z ')
      .replaceAll(r'\Eta', ' H ')
      .replaceAll(r'\Iota', ' I ')
      .replaceAll(r'\Kappa', ' K ')
      .replaceAll(r'\Mu', ' M ')
      .replaceAll(r'\Nu', ' N ')
      .replaceAll(r'\Rho', ' R ')
      .replaceAll(r'\Tau', ' T ')
      .replaceAll(r'\Chi', ' X ');

  @override
  Widget build(BuildContext context) {
    InlineSpan equationWidget;

    var tex = TeX();
    tex.scalingFactor = 2;

    var svg = tex.tex2svg(
      textSource.isNotEmpty ? _replaceUncompatibleTex(textSource) : textSource,
    );

    if (svg.isEmpty) {
      equationWidget = TextSpan(
        text: tex.error,
        style: const TextStyle(color: Colors.red),
      );

      if (tex.error == 'Nothing to render.') {
        equationWidget = const TextSpan(text: '');
      }
    } else {
      var width = tex.width.toDouble();
      equationWidget = WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        child: SvgPicture.string(svg, width: width),
      );
    }
    return Text.rich(
      TextSpan(
        children: [
          equationWidget,
        ],
      ),
    );
  }
}
