import 'package:flutter/material.dart';
import '../models/note.dart';

class NoteScreen extends StatelessWidget {
  final Note note;

  const NoteScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    final TextEditingController _contentConroller =
        TextEditingController(text: note.content);

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
        title: Text(
          note.title,
          style: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _contentConroller,
                maxLines: null,
                style: const TextStyle(fontSize: 16,height: 1.5),
                decoration: const InputDecoration(
                  hintText: "Write you thoughts...",
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