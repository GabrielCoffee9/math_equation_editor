import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';

class Importer {
  ///Returns two values after parsing json, separating them by equal sign.
  ///
  /// left_side_value = right_side_value
  Future<(Map<String, dynamic>, Map<String, dynamic>?)> importEquation() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Importar equação Tex',
      type: FileType.custom,
      allowedExtensions: ['text', 'tex'],
    );
    File? file;
    if (result != null) {
      file = File(result.files.single.path!);
    } else {
      // User canceled the picker
    }

    final String fullMath = await file?.readAsString() ?? '';

    String leftSide = '';
    String? rightSide;

    List<String> equalSignSplit = fullMath.split('=');

    leftSide = equalSignSplit[0];

    if (equalSignSplit.length > 1) {
      rightSide = equalSignSplit[1];
    }

    Map<String, dynamic> parsedLeftSide = jsonDecode(leftSide);
    Map<String, dynamic>? parsedSide = jsonDecode(rightSide ?? '');

    return (parsedLeftSide, parsedSide);
  }
}
