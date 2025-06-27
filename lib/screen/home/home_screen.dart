import 'package:first_flutter/animations/home_screen/sort_dropdown_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:first_flutter/models/note.dart';
import 'package:first_flutter/theme/theme_provider.dart';

import '../../models/sort_option.dart';
import 'constans/home_constants.dart';
import 'widgets/note_list.dart';
import 'widgets/add_note_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Box<Note> _noteBox = Hive.box<Note>('notes');
  SortOption _sortOption = SortOption.byDate;

  void _handleAddNote(String title, String content) {
    setState(() {
      _noteBox.add(Note(title: title, content: content));
    });
  }

  List<Note> _getSortedNotes() {
    final notes = _noteBox.values.toList();

    if (_sortOption == SortOption.favoritesFirst) {
      notes.sort((a, b) {
        if (a.isFavorite == b.isFavorite) {
          return (b.key as int).compareTo(a.key as int);
        }
        return b.isFavorite ? 1 : -1;
      });
    } else {
      notes.sort((a, b) => (b.key as int).compareTo(a.key as int));
    }

    return notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
        actions: [
          SortDropdownButton(
              selected: _sortOption,
              onSelected: (option) {
                setState(() {
                  _sortOption = option;
                });
              }
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () {
              Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
            },
          ),
        ],
      ),
      body: ValueListenableBuilder(
        valueListenable: _noteBox.listenable(),
        builder: (context, Box<Note> box, _) {
          final sortedNotes = _getSortedNotes();

          return Column(
            children: [
              Expanded(
                child: NoteList(
                  notes: sortedNotes,
                  onDismissed: (key) async {
                    await _noteBox.delete(key);
                    setState(() {});
                  },
                  onMarked: (key) async {
                    final note = _noteBox.get(key);
                    if (note != null) {
                      note.isMarked = true;
                      await note.save();
                      setState(() {});
                    }
                  },
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(defaultPadding),
                    child: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        showAddNoteDialog(
                          context: context,
                          onSave: _handleAddNote,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}