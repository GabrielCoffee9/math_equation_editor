import 'package:fluent_ui/fluent_ui.dart';

import '../export/export_jpeg_page.dart';
import '../export/export_pdf_page.dart';
import '../export/export_png_page.dart';
import '../export/export_svg_page.dart';
import '../export/export_tex_page.dart';
import '../export/export_text_page.dart';

class ExportFlyout extends StatelessWidget {
  const ExportFlyout({super.key, this.tex = ''});
  final String tex;
  @override
  Widget build(BuildContext context) {
    var exportFlyoutController = FlyoutController();
    return FlyoutTarget(
      controller: exportFlyoutController,
      child: Button(
        onPressed: () {
          exportFlyoutController.showFlyout(
            builder: (context) {
              return MenuFlyout(
                items: [
                  MenuFlyoutSubItem(
                    text: const Text('Texto'),
                    items: (context) {
                      return [
                        MenuFlyoutItem(
                            text: const Text('Texto comum'),
                            onPressed: () {
                              showExportDialog(
                                context,
                                'texto comum',
                                tex,
                              );
                            }),
                        MenuFlyoutItem(
                            text: const Text('TeX'),
                            onPressed: () {
                              showExportDialog(
                                context,
                                'TeX',
                                tex,
                              );
                            }),
                      ];
                    },
                  ),
                  MenuFlyoutSubItem(
                    text: const Text('Imagem'),
                    items: (context) {
                      return [
                        MenuFlyoutItem(
                            text: const Text('PNG'),
                            onPressed: () {
                              showExportDialog(
                                context,
                                'PNG',
                                tex,
                              );
                            }),
                        MenuFlyoutItem(
                            text: const Text('JPEG'),
                            onPressed: () {
                              showExportDialog(
                                context,
                                'JPEG',
                                tex,
                              );
                            }),
                        MenuFlyoutItem(
                            text: const Text('SVG'),
                            onPressed: () {
                              showExportDialog(
                                context,
                                'SVG',
                                tex,
                              );
                            }),
                      ];
                    },
                  ),
                  MenuFlyoutItem(
                      text: const Text('PDF'),
                      onPressed: () {
                        showExportDialog(
                          context,
                          'PDF',
                          tex,
                        );
                      }),
                ],
              );
            },
          );
        },
        child: const Text('Exportar equação'),
      ),
    );
  }

  void showExportDialog(
      BuildContext context, String extension, String tex) async {
    Map<String, Widget> extensionList = {
      'texto comum': ExportTextPage(text: tex),
      'TeX': ExportTexPage(tex: tex),
      'SVG': ExportSvgPage(tex: tex),
      'PNG': ExportPngPage(tex: tex),
      'JPEG': ExportJpegPage(tex: tex),
      'PDF': ExportPdfPage(tex: tex),
    };

    await showDialog<String>(
      dismissWithEsc: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints(maxWidth: 1024, maxHeight: 650),
        title: Text('Exportar $extension'),
        content: extensionList[extension],
      ),
    );
  }
}
