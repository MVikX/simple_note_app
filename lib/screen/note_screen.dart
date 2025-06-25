import 'package:flutter/material.dart';
import '../models/note.dart';

// layout & spacing
const double _defaultPadding = 16.0;
const double _cardBorderRadius = 16.0;

// text styles
const double _noteFontSize = 16.0;
const double _noteLineHeight = 1.5;

// shadow
const double _shadowBlurRadius = 10.0;
const Offset _shadowOffset = Offset(0, 5);
const Color _shadowColor = Color.fromRGBO(0, 0, 0, 0.05);

// snackbar
const Duration _snackDuration = Duration(seconds: 1);



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
        duration: _snackDuration,
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
        child: Padding(
          padding: const EdgeInsets.all(_defaultPadding),
          child: Container(
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius: BorderRadius.circular(_cardBorderRadius),
              boxShadow: [
                BoxShadow(
                  color: _shadowColor,
                  blurRadius: _shadowBlurRadius,
                  offset: _shadowOffset,
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(_defaultPadding),
              child: TextField(
                controller: _contentController,
                maxLines: null,
                style: const TextStyle(
                  fontSize: _noteFontSize,
                  height: _noteLineHeight,
                ),
                decoration: const InputDecoration(
                  hintText: "Write your thoughts...",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}