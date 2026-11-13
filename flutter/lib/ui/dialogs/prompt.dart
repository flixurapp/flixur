import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:flutter_hooks/flutter_hooks.dart";
import "package:material_ui/material_ui.dart";

/// The widget shown for a prompt dialog.
class const PromptDialog({
  required final String title,
  final String? submitText,
  final String? hintText,
  final List<Widget>? content,
  final int? maxLength,
  super.key,
}) extends HookWidget {
  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    void submit() {
      Navigator.of(context).pop(controller.text.trim());
    }

    return AlertDialog(
      title: Text(title),
      content: SingleChildScrollView(
        child: Column(
          children: [
            ...?content,
            FlixurInput(
              textField: (decoration) => TextField(
                autofocus: true,
                controller: controller,
                onSubmitted: (_) => submit(),
                decoration: decoration.copyWith(hintText: hintText),
                maxLength: maxLength,
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
        TextButton(onPressed: submit, child: Text(submitText ?? t.btn_save)),
      ],
    );
  }
}
