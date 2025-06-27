import 'package:flutter/material.dart';

Future<void> showAddNoteDialog({
  required BuildContext context,
  required void Function(String title, String content) onSave,
}) async {
  final titleController = TextEditingController();
  final contentController = TextEditingController();

  await showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("New note"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: titleController,
            decoration: const InputDecoration(hintText: "Heading"),
          ),
          TextField(
            controller: contentController,
            decoration: const InputDecoration(hintText: "Content"),
            keyboardType: TextInputType.multiline,
            maxLines: null,
            textInputAction: TextInputAction.newline,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            onSave(titleController.text, contentController.text);
            Navigator.of(context).pop();
          },
          child: const Text("Save"),
        ),
      ],
    ),
  );
}