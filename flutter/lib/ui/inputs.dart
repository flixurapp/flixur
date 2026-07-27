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
    required this.textField,
    this.errorText,
    super.key,
  });
  final String label;
  // TextField builder. Supplied an InputDecoration to use.
  final Widget Function(InputDecoration decoration) textField;

  // Forwarded errorText to the input decoration. Used for error colors.
  final String? errorText;

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
        textField(
          InputDecoration(
            errorText: errorText,
            hintStyle: .new(
              color:
                  (errorText != null
                          ? context.colors.error
                          : context.colors.text)
                      .withValues(alpha: 0.5),
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
          ),
        ),
      ],
    );
  }
}
