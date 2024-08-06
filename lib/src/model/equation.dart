import 'package:fluent_ui/fluent_ui.dart';
import 'package:math_keyboard/math_keyboard.dart';

import 'exporter.dart';
import 'importer.dart';

class Equation {
  MathFieldEditingController leftExpression = MathFieldEditingController();
  MathFieldEditingController rightExpression = MathFieldEditingController();

  static const allowedExportExtensions = {
    'png',
    'jpeg',
    'svg',
    'pdf',
    'text',
    'tex',
  };

  static String texToText(String teX) {
    return Exporter.texToText(teX);
  }

  Future<bool> importEquation() async {
    try {
      final importer = Importer();

      var importerResult = await importer.importEquation();

      leftExpression.rootFromJson(importerResult.$1);

      if (importerResult.$2 != null) {
        rightExpression.rootFromJson(importerResult.$2!);
      } else {
        rightExpression = MathFieldEditingController();
      }
      return true;
    } catch (e) {
      debugPrint(
          'An error has occurred when trying to import the equation: $e');
      return false;
    }
  }

  Future<bool> exportWidgetAsEquation({
    required GlobalKey targetWidgetKey,
    required String teXString,
    double scale = 2.0,
    required String extension,
    int red = 0,
    int green = 0,
    int blue = 0,
  }) async {
    try {
      final exporter = Exporter();

      bool saveExtensionsResult = false;

      switch (extension) {
        case 'svg':
          saveExtensionsResult = await exporter.saveSVG(teXString);
          break;

        case 'text':
          saveExtensionsResult =
              await exporter.saveTex(teXString, defaultExt: 'txt');
          break;

        case 'tex':
          saveExtensionsResult = await exporter.saveTex(teXString);
          break;

        case 'pdf':
          saveExtensionsResult = await exporter.savePDF(teXString,
              scaleValue: scale, red: red, green: green, blue: blue);
          break;

        default:
          saveExtensionsResult = await exporter.saveWidgetAsImage(
              targetWidgetKey,
              extension: extension,
              pixelRatio: scale);
      }

      return saveExtensionsResult;
    } catch (e) {
      debugPrint(
          'An error has occurred when trying to export the equation : $e');
      return false;
    }
  }

  Future<bool> copyEquationClipboard({
    required GlobalKey targetWidgetKey,
    required String teXString,
    double scale = 2.0,
    required String extension,
    int red = 0,
    int green = 0,
    int blue = 0,
  }) async {
    try {
      final exporter = Exporter();

      bool copyExtensionsResult = false;

      switch (extension) {
        case 'svg':
          copyExtensionsResult = await exporter.copySVG(
            teXString,
            scaleValue: scale,
            red: red,
            green: green,
            blue: blue,
          );
          break;

        case 'text':
          copyExtensionsResult =
              exporter.copyTextClipboard(Exporter.texToText(teXString));
          break;

        case 'tex':
          copyExtensionsResult = exporter.copyTextClipboard(teXString);
          break;

        case 'pdf':
          copyExtensionsResult = await exporter.copyPDF(
            teXString,
            scaleValue: scale,
            red: red,
            green: green,
            blue: blue,
          );
          break;

        default:
          copyExtensionsResult = await exporter.copyWidgetAsImage(
            targetWidgetKey,
            extension: extension,
            pixelRatio: scale,
          );
      }

      return copyExtensionsResult;
    } catch (e) {
      debugPrint(
          'An error has occurred when trying to copy the equation to clipboard : $e');
      return false;
    }
  }

  Future<bool> shareEquation() async {
    try {
      final exporter = Exporter();

      bool shareEquationResult = false;

      shareEquationResult = await exporter.saveTex(
        rightExpression
                .currentEditingValue(placeholderWhenEmpty: false)
                .isNotEmpty
            ? '${leftExpression.rootToJson()} ?=? ${rightExpression.rootToJson()}'
            : leftExpression.rootToJson(),
        defaultExt: 'json',
      );
      return shareEquationResult;
    } catch (e) {
      debugPrint('An error has occurred when trying to share the equation: $e');
      return false;
    }
  }
}
