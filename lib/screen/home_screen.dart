import 'package:first_flutter/models/note.dart';
import 'package:first_flutter/screen/note_screen.dart';
import 'package:first_flutter/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../animations/animation.dart';

// layout & UI constants
const double _defaultPadding = 16.0;
const double _defaultSpacing = 8.0;
const double _cardRadius = 12.0;
const double _titleFontSize = 18.0;
const int _previewMaxLines = 2;

// animation
const Duration _cardAnimDuration = Duration(milliseconds: 300);

// visual colors
const Color _markedBackgroundColor = Color.fromRGBO(66, 66, 66, 0.3);
const Color _markedBorderColor = Color(0xFF757575);
const Color _defaultBorderColor = Color.fromRGBO(0, 0, 0, 0.1);



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box<Note> _noteBox = Hive.box<Note>('notes');
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final Set<int> _markedIndexes = {};

  void _addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("New note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(
                  hintText: "Heading",
                ),
              ),
              TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  hintText: "Content",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _noteBox.add(
                    Note(
                      title: _titleController.text,
                      content: _contentController.text,
                    ),
                  );
                });
                _titleController.clear();
                _contentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(
                  context,
                  listen: false
              ).toggleTheme();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _noteBox.length,
              itemBuilder: (context, index) {
                final note = _noteBox.getAt(index);
                if (note == null) return const SizedBox();

                final isMarked = _markedIndexes.contains(index);

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: _defaultPadding,
                    vertical: _defaultSpacing,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: DropletDismissible(
                      key: ValueKey("note_$index"),
                      onDismissed: () {
                        setState(() {
                          _noteBox.deleteAt(index);
                          _markedIndexes.remove(index);
                        });
                      },
                      onMarked: () {
                        setState(() {
                          _markedIndexes.add(index);
                        });
                      },
                      onTap: () {
                        if (!isMarked) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => NoteScreen(note: note),
                            ),
                          );
                        }
                      },
                      child: AnimatedContainer(
                        duration: _cardAnimDuration,
                        decoration: BoxDecoration(
                          color: isMarked
                              ? _markedBackgroundColor
                              : theme.cardColor,
                          borderRadius: BorderRadius.circular(_cardRadius),
                          border: Border.all(
                            color: isMarked
                                ? _markedBorderColor
                                : _defaultBorderColor,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(_defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                note.title,
                                style: TextStyle(
                                  fontSize: _titleFontSize,
                                  fontWeight: FontWeight.bold,
                                  color: isMarked ? Colors.grey : null,
                                  decoration: isMarked
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none,
                                ),
                              ),
                              const SizedBox(height: _defaultSpacing),
                              Text(
                                note.content,
                                maxLines: _previewMaxLines,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: isMarked
                                      ? Colors.grey
                                      : theme.textTheme.bodyMedium?.color,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.all(_defaultPadding),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNote,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}