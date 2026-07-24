import "package:flixur/ui/theme.dart";
import "package:flutter/material.dart";

class FlixurInput extends StatelessWidget {
  const FlixurInput({
    required this.label,
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.textController,
    this.onSubmitted,
  });
  final String label;

  // passed to TextField
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? textController;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: hintText,
            errorText: errorText,
            hintStyle: .new(
              color:
                  (errorText != null
                          ? context.colors.error
                          : context.colors.text)
                      .withAlpha(255 ~/ 2),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
          obscureText: obscureText,
          controller: textController,
          onSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
