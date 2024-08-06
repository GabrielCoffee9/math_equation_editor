import 'package:fluent_ui/fluent_ui.dart';
import 'package:tex/tex.dart';
import 'package:flutter_svg/flutter_svg.dart';

class RenderTex extends StatelessWidget {
  const RenderTex({
    super.key,
    required this.textSource,
    this.red = 0,
    this.blue = 0,
    this.green = 0,
    this.scaleValue = 2.0,
  });

  final String textSource;

  final int red;
  final int green;
  final int blue;

  final double scaleValue;

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
      .replaceAll(r'\Rho', ' P ')
      .replaceAll(r'\Tau', ' T ')
      .replaceAll(r'\Chi', ' X ')
      .replaceAll(r'\le', r'\leq')
      .replaceAll(r'\ge', r'\geq');

  @override
  Widget build(BuildContext context) {
    TeX tex = TeX();

    InlineSpan equationWidget;

    tex.setColor(red, green, blue);
    tex.scalingFactor = scaleValue;

    var svg = tex.tex2svg(
      textSource.isNotEmpty ? _replaceUncompatibleTex(textSource) : textSource,
    );

    if (svg.isEmpty) {
      equationWidget = TextSpan(
        text: tex.error,
        style: TextStyle(color: Colors.red),
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
        children: [equationWidget],
      ),
    );
  }
}
