import 'dart:convert';

import 'package:fluent_ui/fluent_ui.dart';
import 'package:flutter/material.dart';
import 'package:math_equation_editor/src/model/equation.dart';
import 'package:math_keyboard/math_keyboard.dart';

class EquationViewModel extends ChangeNotifier {
  final Equation _equation = Equation();

  /// Represents if there are two expressions separated by equal sign [=] or just the left expression.
  ValueNotifier<bool> twoExpressions = ValueNotifier(true);

  /// Returns the current left expression in TeX String equivalent.
  String get leftExpressionString =>
      _equation.leftExpression.currentEditingValue(placeholderWhenEmpty: false);

  /// Returns the current right expression in TeX String equivalent.
  String get rightExpressionString => _equation.rightExpression
      .currentEditingValue(placeholderWhenEmpty: false);

  /// Updates the left expression variable maintained by the ViewModel.
  ///
  /// The argument jsonString must be from a [MathFieldEditingController.rootToJson] function,
  /// wich is a equivalent of [root.toJson] function.
  void updateLeftExpression(String jsonString) {
    _equation.leftExpression.rootFromJson(jsonDecode(jsonString));
  }

  /// Updates the right expression variable maintained by the ViewModel.
  ///
  /// The argument jsonString must be from a [MathFieldEditingController.rootToJson] function,
  /// wich is a equivalent of [root.toJson] function.
  void updateRightExpression(String jsonString) {
    _equation.leftExpression.rootFromJson(jsonDecode(jsonString));
  }

  String texToText(String tex) {
    return Equation.texToText(tex);
  }

  MathFieldEditingController get leftExpressionEditing =>
      _equation.leftExpression;

  MathFieldEditingController get rightExpressionEditing =>
      _equation.rightExpression;

  void _checkTwoExpressions() {
    if (rightExpressionString.isEmpty) {
      twoExpressions.value = false;
    } else {
      twoExpressions.value = true;
    }
  }

  Future<void> importEquation() async {
    final importSucess = await _equation.importEquation();
    if (importSucess) {
      _checkTwoExpressions();
      notifyListeners();
    }
  }

  Future<bool> exportEquation({
    required GlobalKey targetWidgetKey,
    required String tex,
    double scale = 2.0,
    required String extensionKey,
    int red = 0,
    int green = 0,
    int blue = 0,
    bool keepEmptyBoxes = true,
  }) async {
    try {
      if (!Equation.allowedExportExtensions.contains(extensionKey)) {
        throw Exception('the given extension: $extensionKey is not allowed');
      }

      // Prevents the > 255 color ranges
      Color rgbColor = Color.fromRGBO(red, green, blue, 1.0);

      bool exportResult = await _equation.exportWidgetAsEquation(
        targetWidgetKey: targetWidgetKey,
        teXString: tex,
        scale: scale,
        extension: extensionKey,
        red: rgbColor.red,
        green: rgbColor.green,
        blue: rgbColor.blue,
        keepEmptyBoxes: keepEmptyBoxes,
      );

      return exportResult;
    } catch (e) {
      return false;
    }
  }

  Future<bool> copyEquationClipboard({
    required GlobalKey targetWidgetKey,
    required String tex,
    double scale = 2.0,
    required String extensionKey,
    int red = 0,
    int green = 0,
    int blue = 0,
    bool keepEmptyBoxes = true,
  }) async {
    try {
      if (!Equation.allowedExportExtensions.contains(extensionKey)) {
        throw Exception('the given extension: $extensionKey is not allowed');
      }

      // Prevents the > 255 color ranges
      Color rgbColor = Color.fromRGBO(red, green, blue, 1.0);

      bool copyResult = await _equation.copyEquationClipboard(
        targetWidgetKey: targetWidgetKey,
        teXString: tex,
        scale: scale,
        extension: extensionKey,
        red: rgbColor.red,
        green: rgbColor.green,
        blue: rgbColor.blue,
        keepEmptyBoxes: keepEmptyBoxes,
      );

      return copyResult;
    } catch (e) {
      return false;
    }
  }

  Future<bool> shareEquation() async {
    return await _equation.shareEquation();
  }
}
