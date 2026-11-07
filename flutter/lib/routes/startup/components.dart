import "package:flixur/ui/inputs.dart";
import "package:material_ui/material_ui.dart";

class StartupButton({
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
