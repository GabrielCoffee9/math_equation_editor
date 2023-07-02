import 'package:fluent_ui/fluent_ui.dart';

class SaveInfoBar extends StatelessWidget {
  const SaveInfoBar({
    Key? key,
    required this.title,
    this.content,
    required this.close,
    this.type,
  }) : super(key: key);

  final String title;
  final Widget? content;
  final VoidCallback? close;

  final InfoBarSeverity? type;

  @override
  Widget build(BuildContext context) {
    return InfoBar(
      title: Text(title),
      content: content,
      action: IconButton(
        icon: const Icon(FluentIcons.clear),
        onPressed: close,
      ),
      severity: type ?? InfoBarSeverity.info,
    );
  }
}
