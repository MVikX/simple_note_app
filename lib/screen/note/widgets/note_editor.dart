import 'package:flutter/material.dart';
import '../../note/constants/note_constants.dart';

class NoteEditor extends StatelessWidget {
  final TextEditingController controller;

  const NoteEditor({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(noteDefaultPadding),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(noteCardBorderRadius),
          boxShadow: [
            BoxShadow(
              color: noteShadowColor,
              blurRadius: noteShadowBlurRadius,
              offset: noteShadowOffset,
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(noteDefaultPadding),
          child: TextField(
            controller: controller,
            maxLines: null,
            style: const TextStyle(
              fontSize: noteFontSize,
              height: noteLineHeight,
            ),
            decoration: const InputDecoration(
              hintText: "Write your thoughts...",
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}