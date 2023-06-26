import 'package:fluent_ui/fluent_ui.dart';
import 'package:math_equation_editor/export/export_tex_page.dart';
import 'package:math_equation_editor/export/export_text_page.dart';

class ExportFlyout extends StatefulWidget {
  const ExportFlyout({super.key, this.tex = ''});
  final String tex;
  @override
  State<ExportFlyout> createState() => _ExportFlyoutState();
}

class _ExportFlyoutState extends State<ExportFlyout> {
  @override
  Widget build(BuildContext context) {
    FlyoutController exportFlyoutController = FlyoutController();
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
                                  context, 'texto comum', widget.tex);
                            }),
                        MenuFlyoutItem(
                            text: const Text('TeX'),
                            onPressed: () {
                              showExportDialog(context, 'TeX', widget.tex);
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
                              showExportDialog(context, 'PNG', widget.tex);
                            }),
                        MenuFlyoutItem(
                            text: const Text('JPEG'),
                            onPressed: () {
                              showExportDialog(context, 'JPEG', widget.tex);
                            }),
                        MenuFlyoutItem(
                            text: const Text('SVG'),
                            onPressed: () {
                              showExportDialog(context, 'SVG', widget.tex);
                            }),
                      ];
                    },
                  ),
                  MenuFlyoutSubItem(
                    text: const Text('Outros'),
                    items: (context) {
                      return [
                        MenuFlyoutItem(
                            text: const Text('PDF'),
                            onPressed: () {
                              showExportDialog(context, 'PDF', widget.tex);
                            }),
                        MenuFlyoutItem(
                            text: const Text('Uint8'),
                            onPressed: () {
                              showExportDialog(context, 'Uint8', widget.tex);
                            }),
                      ];
                    },
                  ),
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
      'texto comum': ExportTextPage(
        text: tex,
      ),
      'TeX': ExportTexPage(
        tex: tex,
      )
    };
    await showDialog<String>(
      dismissWithEsc: true,
      barrierDismissible: true,
      context: context,
      builder: (context) => ContentDialog(
        constraints: const BoxConstraints(maxWidth: 800, maxHeight: 500),
        title: Text('Exportar $extension'),
        content: extensionList[extension],
        // actions: [
        //   FilledButton(
        //     child: const Text('Voltar'),
        //     onPressed: () => Navigator.pop(context),
        //   ),
        // ],
      ),
    );
    setState(() {});
  }
}
