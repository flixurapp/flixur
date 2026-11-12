import "package:flixur/ui/icons.dart";
import "package:flixur/ui/inputs.dart";
import "package:flixur/utils.dart";
import "package:material_ui/material_ui.dart";

Future<void> showErrorDialog(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  await showDialog<void>(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        icon: Iconify("x-circle-bold", color: ctx.colors.error, size: 40),
        title: Text(title),
        content: SingleChildScrollView(child: Text(message)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.btn_ok),
          ),
        ],
      );
    },
  );
}

/// Ask the user for confirmation.
Future<bool> showConfirmDialog(
  BuildContext context, {
  String? title,
  String? message,
  String? okText,
}) async {
  return await showDialog<bool>(
        context: context,
        builder: (ctx) {
          return AlertDialog(
            icon: const Iconify("question", size: 40),
            title: Text(title ?? t.confirmation_dialog_title),
            content: message != null
                ? SingleChildScrollView(child: Text(message))
                : null,
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: Text(t.btn_cancel),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: Text(okText ?? t.btn_confirm),
              ),
            ],
          );
        },
      ) ??
      false;
}

/// Prompt for a single string.
Future<String?> showPromptDialog(
  BuildContext context, {
  required String title,
  String? submitText,
  String? hintText,
  List<Widget>? content,
  int? maxLength,
}) async {
  final controller = TextEditingController();
  return await showDialog<String>(
    context: context,
    builder: (ctx) {
      void submit() {
        Navigator.of(ctx).pop(controller.text.trim());
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
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.btn_cancel),
          ),
          TextButton(onPressed: submit, child: Text(submitText ?? t.btn_save)),
        ],
      );
    },
  );
}
