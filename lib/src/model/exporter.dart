import 'dart:io';
import 'dart:ui';

import 'package:file_picker/file_picker.dart';
import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/rendering.dart';
import 'package:pasteboard/pasteboard.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tex/tex.dart';
import 'package:pdf/widgets.dart' as pw;

class Exporter {
  static String texToText(String tex) {
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

  static String replaceUncompatibleTex(String textSource) => textSource
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

  Future<bool> saveTex(String texsrc, {String defaultExt = 'tex'}) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        lockParentWindow: true,
        type: FileType.custom,
        allowedExtensions: ['json'],
        dialogTitle: 'Salvar como',
        fileName: 'export.$defaultExt',
      );

      if (outputFile == null) return false;

      File file = File(outputFile);
      await file.writeAsString(texsrc);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> copyWidgetAsImage(
    GlobalKey targetKey, {
    String extension = 'png',
    double pixelRatio = 2.0,
  }) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      Directory tempFolder = Directory('${tempDir.path}\\math_equation_temp');

      if (!tempFolder.existsSync()) {
        tempFolder = await tempFolder.create(recursive: true);
      }

      // ignore: use_build_context_synchronously
      if (!targetKey.currentContext!.mounted) return false;
      final RenderRepaintBoundary boundary =
          targetKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: pixelRatio);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final pngBytes = byteData!.buffer.asUint8List();

      File file = File('${tempFolder.path}\\export.$extension');
      await file.writeAsBytes(pngBytes);

      await copyFileClipboard(file);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> saveWidgetAsImage(
    GlobalKey targetKey, {
    String extension = 'png',
    double pixelRatio = 2.0,
  }) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        lockParentWindow: true,
        type: FileType.image,
        allowedExtensions: ['png', 'jpeg'],
        dialogTitle: 'Salvar como',
        fileName: 'export.$extension',
      );

      if (outputFile == null || outputFile.isEmpty) return false;

      // ignore: use_build_context_synchronously
      if (!targetKey.currentContext!.mounted) return false;
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

  Future<bool> copySVG(
    String texsrc, {
    double scaleValue = 2.0,
    int red = 0,
    int green = 0,
    int blue = 0,
  }) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      var tex = TeX();
      tex.setColor(red, green, blue);
      tex.scalingFactor = scaleValue;
      var svgImageData =
          tex.tex2svg(replaceUncompatibleTex(texsrc), displayStyle: true);

      if (svgImageData.isEmpty) {
        throw Exception('Error found on parsing TeX : ${tex.error}');
      }

      Directory tempFolder = Directory('${tempDir.path}\\math_equation_temp');

      if (!tempFolder.existsSync()) {
        tempFolder = await tempFolder.create(recursive: true);
      }

      final file = File('${tempFolder.path}\\export.svg');
      await file.writeAsString(svgImageData);

      return await copyFileClipboard(file);
    } catch (e) {
      debugPrint(
          'An error has occurred when trying to copy the equation to clipboard : $e');
      return false;
    }
  }

  Future<bool> saveSVG(
    String texsrc, {
    double scaleValue = 2.0,
    String defaultExt = 'svg',
    int red = 0,
    int green = 0,
    int blue = 0,
  }) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        lockParentWindow: true,
        type: FileType.custom,
        allowedExtensions: ['svg'],
        dialogTitle: 'Salvar como',
        fileName: 'export.$defaultExt',
      );

      if (outputFile == null) return false;

      var tex = TeX();
      tex.setColor(red, green, blue);
      tex.scalingFactor = scaleValue;
      var svgImageData =
          tex.tex2svg(replaceUncompatibleTex(texsrc), displayStyle: true);

      if (svgImageData.isEmpty) {
        throw Exception('Error found on parsing TeX : ${tex.error}');
      }

      File file = File(outputFile);
      await file.writeAsString(svgImageData);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> copyPDF(
    String texsrc, {
    double scaleValue = 2.0,
    int red = 0,
    int green = 0,
    int blue = 0,
  }) async {
    try {
      final Directory tempDir = await getTemporaryDirectory();

      final pdf = pw.Document();

      var tex = TeX();

      tex.setColor(red, green, blue);
      tex.scalingFactor = scaleValue;

      final svgImage = pw.SvgImage(
          svg: tex.tex2svg(replaceUncompatibleTex(texsrc), displayStyle: true));

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(child: svgImage),
        ),
      );

      Directory tempFolder = Directory('${tempDir.path}\\math_equation_temp');

      if (!tempFolder.existsSync()) {
        tempFolder = await tempFolder.create(recursive: true);
      }

      final file = File('${tempFolder.path}\\export.pdf');
      await file.writeAsBytes(await pdf.save());

      return await copyFileClipboard(file);
    } catch (e) {
      debugPrint(
        'An error has occurred when trying to copy the equation as PDF : $e',
      );
      return false;
    }
  }

  Future<bool> savePDF(
    String texsrc, {
    double scaleValue = 2.0,
    int red = 0,
    int green = 0,
    int blue = 0,
  }) async {
    try {
      String? outputFile = await FilePicker.platform.saveFile(
        lockParentWindow: true,
        type: FileType.custom,
        allowedExtensions: ['pdf'],
        dialogTitle: 'Salvar como',
        fileName: 'export.pdf',
      );

      if (outputFile == null) return false;

      final pdf = pw.Document();

      var tex = TeX();

      tex.setColor(red, green, blue);
      tex.scalingFactor = scaleValue;

      final svgImageData =
          tex.tex2svg(replaceUncompatibleTex(texsrc), displayStyle: true);

      if (svgImageData.isEmpty) {
        throw Exception('Error found on parsing TeX : ${tex.error}');
      }

      final svgImage = pw.SvgImage(svg: svgImageData);

      pdf.addPage(
        pw.Page(
          build: (pw.Context context) => pw.Center(child: svgImage),
        ),
      );

      final file = File(outputFile);
      await file.writeAsBytes(await pdf.save());

      return true;
    } catch (e) {
      return false;
    }
  }

  bool copyTextClipboard(String text) {
    try {
      Pasteboard.writeText(text);
      return true;
    } on Exception catch (e) {
      debugPrint('Error when trying to copy to clipboard : $e');
      return false;
    }
  }

  Future<bool> copyFileClipboard(File file) async {
    return await Pasteboard.writeFiles([file.path]);
  }
}
