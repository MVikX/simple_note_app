import 'package:first_flutter/models/note.dart';
import 'package:first_flutter/screen/note_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Note> _notes = [];
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();


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
                decoration: const InputDecoration(hintText: "Heading"),
              ),

              TextField(
                controller: _contentController,
                decoration: const InputDecoration(hintText:"Content"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: (){
                setState(() {
                  _notes.add(Note(
                    title: _titleController.text,
                    content: _contentController.text,
                  ));
                });
                _titleController.clear();
                _contentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text("Save"),
            )
          ],
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _notes.length,
              itemBuilder: (context, index) {
                final note = _notes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(note: note),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                      vertical: 8,
                    ),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      ),
                      color: Colors.yellow[50],
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              note.title,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8,),
                            Text(
                              note.content,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: Colors.grey[800]
                              ),
                            ),
                          ],
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
                padding: const EdgeInsets.all(16),
                child: IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _addNote,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}