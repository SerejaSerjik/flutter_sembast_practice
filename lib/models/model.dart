enum NoteState {
  GETALL,
  INSERT,
  UPDATE,
  DELETE,
  DELETE_ALL,
  NOOP,
}

class Note {
  int id;

  NoteState state;

  final String body;

  Note({this.body, this.state, this.id});

  Note copyWith({String body, NoteState state, int id}) {
    return Note(
      body: body ?? this.body,
      state: state ?? this.state,
      id: id ?? this.id,
    );
  }

  Note.fromMap(Map<String, dynamic> map)
      : this.body = map['body'],
        this.state = NoteState.values[map['state']];

  Map<String, dynamic> toMap() {
    return {
      'body': body,
      'state': state.index,
    };
  }
}
