import "package:flixur/ui/inputs.dart";
import "package:material_ui/material_ui.dart";

/// Scaffold for startup pages.
class const StartupBody({
  required final Widget child,
  final Color? backgroundColor,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: LayoutBuilder(
        builder: (context, constraints) => SingleChildScrollView(
          child: Container(
            alignment: .center,
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            padding: const .symmetric(horizontal: 20, vertical: 32),
            child: child,
          ),
        ),
      ),
    );
  }
}

class const StartupButton({
  required final String text,
  super.key,
  final void Function()? onPressed,
  final bool isLoading = false,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: .new(
        padding: .all(const .symmetric(vertical: 18)),
        textStyle: .all(const .new(fontSize: 24, fontWeight: .w500)),
      ),
      child: isLoading ? const LoadingSpinner() : Text(text.toUpperCase()),
    );
  }
}
