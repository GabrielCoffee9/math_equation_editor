import 'dart:io';

import 'package:file_picker/file_picker.dart';

class Exporter {
  String texToText(String tex) {
    return tex
        .replaceAll(r'\times', '×')
        .replaceAll(r'\int', '∫')
        .replaceAll('_', '')
        .replaceAll('{', '')
        .replaceAll('}', '');
  }

  Future<bool> saveTex(String tex, {String? defaultExt = 'tex'}) async {
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
}
