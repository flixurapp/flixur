import "package:flixur/utils.dart";
import "package:flutter/material.dart";

class LoadingSpinner extends StatelessWidget {
  const LoadingSpinner({super.key, this.color});

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: color ?? DefaultTextStyle.of(context).style.color,
      ),
    );
  }
}

// A line with "OR" in the middle. ---- OR ----
class OrLine extends StatelessWidget {
  const OrLine({super.key, this.padding = 6});

  // Vertical padding for the line.
  final double padding;

  @override
  Widget build(BuildContext context) {
    final line = Expanded(
      child: Divider(
        color: context.colors.textMuted,
        thickness: 1,
      ),
    );

    return Row(
      children: [
        line,
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: 10,
            vertical: padding,
          ),
          child: Text(
            t.or_line,
            style: TextStyle(
              color: context.colors.textMuted,
              fontWeight: FontWeight.w500,
              fontSize: 14,
            ),
          ),
        ),
        line,
      ],
    );
  }
}

class FlixurInput extends StatelessWidget {
  const FlixurInput({
    required this.label,
    super.key,
    this.hintText,
    this.errorText,
    this.obscureText = false,
    this.textController,
    this.focusNode,
    this.onSubmitted,
  });
  final String label;

  // passed to TextField
  final String? hintText;
  final String? errorText;
  final bool obscureText;
  final TextEditingController? textController;
  final FocusNode? focusNode;
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
          focusNode: focusNode,
        ),
      ],
    );
  }
}
