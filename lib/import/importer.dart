import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class Importer {
  ///Returns two values after parsing json, separating them by equal sign.
  ///
  /// left_side_value = right_side_value
  Future<(Map<String, dynamic>, Map<String, dynamic>?)> importEquation() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        dialogTitle: 'Importar equação compartilhada',
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      File? file;
      if (result != null) {
        file = File(result.files.single.path!);
      } else {
        // User canceled the picker
        throw (Exception('user canceled'));
      }

      final String fullMath = await file.readAsString();

      String leftSide = '';
      String? rightSide;

      List<String> equalSignSplit = fullMath.split('?=?');

      leftSide = equalSignSplit[0];

      if (equalSignSplit.length > 1) {
        rightSide = equalSignSplit[1];
      }

      Map<String, dynamic> parsedLeftSide = jsonDecode(leftSide);
      Map<String, dynamic>? parsedSide;

      if (rightSide != null) {
        parsedSide = jsonDecode(rightSide);
      }

      return (parsedLeftSide, parsedSide);
    } catch (e) {
      rethrow;
    }
  }
}
