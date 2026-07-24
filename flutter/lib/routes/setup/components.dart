import "package:flixur/ui/inputs.dart";
import "package:flutter/material.dart";

class SetupButton extends StatelessWidget {
  const SetupButton({
    required this.text,
    super.key,
    this.onPressed,
    this.isLoading = false,
  });

  final String text;
  final bool isLoading;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: .new(
        padding: .all(const .symmetric(vertical: 18)),
        textStyle: .all(
          const .new(fontSize: 24, fontWeight: .w500),
        ),
      ),
      child: isLoading ? const LoadingSpinner() : Text(text.toUpperCase()),
    );
  }
}
