import 'package:fluent_ui/fluent_ui.dart';

class CopySaveButtons extends StatelessWidget {
  const CopySaveButtons({
    super.key,
    required this.copyOnPressed,
    required this.saveOnPressed,
  });

  final void Function()? copyOnPressed;
  final void Function()? saveOnPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsetsDirectional.only(end: 10),
            child: FilledButton(
              onPressed: copyOnPressed,
              child: const Text('Copiar'),
            ),
          ),
        ),
        Expanded(
          child: FilledButton(
            onPressed: saveOnPressed,
            child: const Text('Salvar'),
          ),
        ),
      ],
    );
  }
}
