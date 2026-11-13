import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

/// The widget shown for a prompt dialog.
class const PromptDialog({
  required final String title,
  final String? submitText,
  final String? hintText,
  final List<Widget>? content,
  final int? maxLength,
  super.key,
}) extends StatefulWidget {
  @override
  State<PromptDialog> createState() => _PromptDialogState();
}

class _PromptDialogState extends State<PromptDialog> {
  final _controller = TextEditingController();

  void _submit() {
    Navigator.of(context).pop(_controller.text.trim());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...?widget.content,
            FlixurInput(
              textField: (decoration) => TextField(
                autofocus: true,
                controller: _controller,
                onSubmitted: (_) => _submit(),
                decoration: decoration.copyWith(hintText: widget.hintText),
                maxLength: widget.maxLength,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(t.btn_cancel),
        ),
        TextButton(
          onPressed: _submit,
          child: Text(widget.submitText ?? t.btn_save),
        ),
      ],
    );
  }
}
