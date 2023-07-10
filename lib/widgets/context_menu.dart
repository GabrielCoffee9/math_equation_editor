import 'package:fluent_ui/fluent_ui.dart';

class ContextMenu extends StatelessWidget {
  const ContextMenu({
    super.key,
    required this.primaryItems,
    required this.child,
  });

  final Widget child;

  final List<CommandBarItem> primaryItems;

  @override
  Widget build(BuildContext context) {
    final contextController = FlyoutController();
    final contextAttachKey = GlobalKey();
    return GestureDetector(
      onSecondaryTapUp: (d) {
        // This calculates the position of the flyout according to the parent navigator
        final targetContext = contextAttachKey.currentContext;
        if (targetContext == null) return;
        final box = targetContext.findRenderObject() as RenderBox;
        final position = box.localToGlobal(
          d.localPosition,
          ancestor: Navigator.of(context).context.findRenderObject(),
        );
        contextController.showFlyout(
          barrierColor: Colors.black.withOpacity(0.1),
          position: position,
          builder: (context) {
            return FlyoutContent(
              child: SizedBox(
                width: 150.0,
                child: CommandBar(
                  primaryItems: primaryItems,
                ),
              ),
            );
          },
        );
      },
      child: FlyoutTarget(
        key: contextAttachKey,
        controller: contextController,
        child: child,
      ),
    );
  }
}
