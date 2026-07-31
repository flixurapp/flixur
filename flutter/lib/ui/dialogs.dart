import "package:flixur/ui/icons.dart";
import "package:flixur/utils.dart";
import "package:flutter/material.dart";

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
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(t.btn_ok),
          ),
        ],
      );
    },
  );
}
