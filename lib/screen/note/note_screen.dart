import 'package:flutter/material.dart';
import 'package:first_flutter/models/note.dart';

import '../note/constants/note_constants.dart';
import '../note/widgets/note_editor.dart';

class NoteScreen extends StatefulWidget {
  final Note note;

  const NoteScreen({super.key, required this.note});

  @override
  State<NoteScreen> createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController(text: widget.note.content);
  }

  void _saveNote() async {
    widget.note.content = _contentController.text;
    await widget.note.save();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Note saved'),
        duration: noteSnackDuration,
      ),
    );
  }

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        elevation: 0,
        title: Text(
          widget.note.title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.save_alt),
            tooltip: "Save",
            onPressed: _saveNote,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: NoteEditor(controller: _contentController),
      ),
    );
  }
}