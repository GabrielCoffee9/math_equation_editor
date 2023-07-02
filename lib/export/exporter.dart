import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:tex/tex.dart';
import 'package:pdf/widgets.dart' as pw;

import '../widgets/save_info_bar.dart';

class Exporter {
  String texToText(String tex) {
    return tex
        .replaceAll(r'\times', '×')
        .replaceAll(r'\int', '∫')
        .replaceAll('_', '')
        .replaceAll(r'\div', '÷')
        .replaceAll(r'\sum', 'Σ')
        .replaceAll(r'\ln', '㏑')
        .replaceAll(r'\alpha', 'α')
        .replaceAll(r'\beta', 'β')
        .replaceAll(r'\gamma', 'γ')
        .replaceAll(r'\delta', 'δ')
        .replaceAll(r'\epsilon', 'ε')
        .replaceAll(r'\zeta', 'ζ')
        .replaceAll(r'\eta', 'η')
        .replaceAll(r'\theta', 'θ')
        .replaceAll(r'\iota', 'ι')
        .replaceAll(r'\kappa', 'κ')
        .replaceAll(r'\lambda', 'λ')
        .replaceAll(r'\mu', 'μ')
        .replaceAll(r'\nu', 'ν')
        .replaceAll(r'\xi', 'ξ')
        .replaceAll(r'\pi', 'π')
        .replaceAll(r'\rho', 'ρ')
        .replaceAll(r'\sigma', 'σ')
        .replaceAll(r'\tau', 'τ')
        .replaceAll(r'\upsilon', 'υ')
        .replaceAll(r'\phi', 'φ')
        .replaceAll(r'\chi', 'χ')
        .replaceAll(r'\psi', 'ψ')
        .replaceAll(r'\omega', 'ω')
        .replaceAll(r'\Alpha', 'Α')
        .replaceAll(r'\Beta', 'Β')
        .replaceAll(r'\Gamma', 'Γ')
        .replaceAll(r'\Delta', 'Δ')
        .replaceAll(r'\Epsilon', 'Ε')
        .replaceAll(r'\Zeta', 'Ζ')
        .replaceAll(r'\Eta', 'Η')
        .replaceAll(r'\Theta', 'Θ')
        .replaceAll(r'\Iota', 'Ι')
        .replaceAll(r'\Kappa', 'Κ')
        .replaceAll(r'\Lambda', 'Λ')
        .replaceAll(r'\Mu', 'Μ')
        .replaceAll(r'\Nu', 'Ν')
        .replaceAll(r'\Xi', 'Ξ')
        .replaceAll(r'\Pi', 'Π')
        .replaceAll(r'\Rho', 'Ρ')
        .replaceAll(r'\Sigma', 'Σ')
        .replaceAll(r'\Tau', 'Τ')
        .replaceAll(r'\Upsilon', 'Υ')
        .replaceAll(r'\Phi', 'Φ')
        .replaceAll(r'\Chi', 'Χ')
        .replaceAll(r'\Psi', 'Ψ')
        .replaceAll(r'\Omega', 'Ω')
        .replaceAll(r'\Box', '□')
        .replaceAll(r'\circ', '⚬')
        .replaceAll(r'\sin', 'sin')
        .replaceAll(r'\cos', 'cos')
        .replaceAll(r'\tan', 'tan')
        .replaceAll(r'\infty', '∞')
        .replaceAll(r'\log', 'log')
        .replaceAll(r'\sqrt', '√')
        .replaceAll(r'\cdot', '·')
        .replaceAll(r'\ge', '≥')
        .replaceAll(r'\le', '≤');
  }

  Future<bool> saveTex(String tex, {String defaultExt = 'tex'}) async {
    String? outputFile = await FilePicker.platform.saveFile(
      lockParentWindow: true,
      type: FileType.custom,
      allowedExtensions: ['txt', 'tex'],
      dialogTitle: 'Salvar como',
      fileName: 'export.$defaultExt',
    );

    if (outputFile == null) {
      return false;
    }

    File file = File(outputFile);
    await file.writeAsString(tex);

    return true;
  }

  Future<bool> savePDF(String texsrc) async {
    String? outputFile = await FilePicker.platform.saveFile(
      lockParentWindow: true,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      dialogTitle: 'Salvar como',
      fileName: 'export.pdf',
    );

    if (outputFile == null) {
      return false;
    }

    final pdf = pw.Document();

    var tex = TeX();
    tex.scalingFactor = 2.0;

    final svgImage = pw.SvgImage(svg: tex.tex2svg(texsrc, displayStyle: true));

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: svgImage,
          ); // Center
        },
      ),
    );

    final file = File(outputFile);
    await file.writeAsBytes(await pdf.save());

    return true;
  }

  Future<bool> saveSVGImage(
    String texSource,
    double scaleValue, {
    String defaultExt = 'svg',
    int red = 0,
    int green = 0,
    int blue = 0,
  }) async {
    String? outputFile = await FilePicker.platform.saveFile(
      lockParentWindow: true,
      type: FileType.custom,
      allowedExtensions: ['svg'],
      dialogTitle: 'Salvar como',
      fileName: 'export.$defaultExt',
    );

    if (outputFile == null) {
      return false;
    }

    var tex = TeX();
    tex.setColor(red, green, blue);
    tex.scalingFactor = scaleValue;
    var svgImageData = tex.tex2svg(texSource, displayStyle: true);

    File file = File(outputFile);
    await file.writeAsString(svgImageData);

    return true;
  }

  Future<bool> saveWidgetAsImage(
    BuildContext context,
    GlobalKey targetKey, {
    String defaultExt = 'png',
    double pixelRatio = 2.0,
  }) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        lockParentWindow: true,
        type: FileType.image,
        allowedExtensions: ['png', 'jpeg'],
        dialogTitle: 'Salvar como',
        fileName: 'export.$defaultExt',
      );

      if (outputFile == null || outputFile.isEmpty) {
        return false;
      }

      // ignore: use_build_context_synchronously
      if (!context.mounted) return false;
      final RenderRepaintBoundary boundary =
          targetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      File file = File(outputFile);
      await file.writeAsBytes(pngBytes);
      return true;
    } catch (e) {
      return false;
    }
  }

  void displayExportResult(BuildContext context, String title, String info,
      [bool sucess = true]) {
    if (!context.mounted) return;
    displayInfoBar(
      context,
      builder: (context, close) => SaveInfoBar(
        title: title,
        content: Text(info),
        close: close,
        type: sucess ? InfoBarSeverity.success : InfoBarSeverity.error,
      ),
    );
    if (sucess) {
      Navigator.of(context).pop();
    }
  }
}
