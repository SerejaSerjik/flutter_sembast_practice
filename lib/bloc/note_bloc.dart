import 'dart:async';
import 'package:sembast_practice/models/model.dart';
import 'package:sembast_practice/database/crud.dart';

class NoteBloc {
  final DBLogic logic;

  StreamController<List<Note>> _notes = StreamController.broadcast();

  StreamController<Note> _incoming = StreamController();

  Stream<List<Note>> get outgoing => _notes.stream;

  StreamSink<Note> get inSink => _incoming.sink;

  NoteBloc(this.logic) {
    _incoming.stream.listen((note) async {
      switch (note.state) {
        case NoteState.INSERT:
          logic.insert(note).then((_) async => {
                _notes.add(
                  await logic.getAllNotes(),
                )
              });
          break;
        case NoteState.UPDATE:
          logic.update(note).then((_) async => {
                _notes.add(
                  await logic.getAllNotes(),
                )
              });
          break;
        case NoteState.GETALL:
          _notes.add(
            await logic.getAllNotes(),
          );
          break;
        case NoteState.DELETE:
          logic.delete(note).then((_) async => {
                _notes.add(
                  await logic.getAllNotes(),
                )
              });
          break;
        case NoteState.DELETE_ALL:
          logic.deleteAll().then((_) async => {
                _notes.add(
                  await logic.getAllNotes(),
                )
              });
          break;
        case NoteState.NOOP:
          break;
      }
    });
  }

  void dispose() {
    _incoming.close();
    _notes.close();
  }
}
