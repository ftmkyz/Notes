import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:notes_app/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyNotesApp extends StatelessWidget {
  const MyNotesApp({super.key, Key? keys});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const NotesScreen(),
    );
  }
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key, Key? keys});

  @override
  // ignore: library_private_types_in_public_api
  _NotesScreenState createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  List<String> notes = [];
  late SharedPreferences _prefs;
  final TextEditingController _textEditingController = TextEditingController();

  List<Uint8List> bytes = [];
  void _showEditDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Edit Note Content'),
          content: TextField(
            minLines: 1,
            maxLines: 15,
            controller: _textEditingController,
            decoration:
                const InputDecoration.collapsed(hintText: 'Edit content'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _updateNote(index, _textEditingController.text);
                Navigator.of(context).pop();
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _loadNotes();
  }

  Future<void> _loadNotes() async {
    _prefs = await SharedPreferences.getInstance();
    setState(() {
      notes = _prefs.getStringList('notes') ?? [];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('My Notes')),
        backgroundColor: Colors.white,
        body: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: notes.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                //_showEditDialog(index);
              },
              child: CardPage(
                title: '',
                content: notes[index],
                test: ButtonBar(
                  children: <Widget>[
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: const Color.fromARGB(255, 80, 85, 80),
                      onPressed: () {
                        setState(() {
                          _deleteNote(index);
                        });
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Color.fromARGB(255, 80, 85, 80),
                      ),
                      onPressed: () {
                        _textEditingController.text = notes[index];
                        _showEditDialog(index);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _addNote();
          },
          tooltip: 'Add Note',
          foregroundColor: Colors.black,
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _addNote() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        _textEditingController.clear();
        return AlertDialog(
          content: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: TextFormField(
              maxLines: 50,
              minLines: 5,
              decoration: const InputDecoration.collapsed(hintText: 'Add Note'),
              autofocus: true,
              controller: _textEditingController,
              onChanged: (value) {},
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                setState(() {
                  _saveNote(_textEditingController.text);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteNote(int index) async {
    setState(() {
      notes.removeAt(index);
    });
    await _prefs.setStringList('notes', notes);
  }

  Future<void> _updateNote(int index, String updatedContent) async {
    setState(() {
      notes[index] = updatedContent;
    });
    await _prefs.setStringList('notes', notes);
  }

  Future<void> _saveNote(String note) async {
    setState(() {
      notes.add(note);
    });
    await _prefs.setStringList('notes', notes);
  }
}
