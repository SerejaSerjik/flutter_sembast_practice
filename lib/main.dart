import 'package:flutter/material.dart';

import 'bloc/note_bloc.dart';
import 'bloc/provider.dart';

import './models/model.dart';
import './database/crud.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<NoteBloc>(
      builder: (_, NoteBloc bloc) =>
          bloc ??
          NoteBloc(
            DBLogic(),
          ),
      onDispose: (_, bloc) => bloc.dispose(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: DefaultTabController(
          length: 2,
          child: MyHomePage(),
        ),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = Provider.of<NoteBloc>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Notes CRUD'),
        bottom: TabBar(
          tabs: [
            Tab(
              icon: Icon(Icons.info),
              text: 'Note Page',
            ),
            Tab(
              icon: Icon(Icons.input),
              text: 'Input Form',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          FormTab(bloc),
          InfoTab(bloc),
        ],
      ),
    );
  }
}

class FormTab extends StatefulWidget {
  final NoteBloc bloc;

  FormTab(this.bloc);

  @override
  _FormTabState createState() => _FormTabState();
}

class _FormTabState extends State<FormTab> {
  @override
  void initState() {
    super.initState();
    widget.bloc.inSink.add(Note(state: NoteState.GETALL));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.bloc.outgoing,
      builder: (context, AsyncSnapshot<List<Note>> snapshot) {
        if (snapshot.hasData) {
          return CircularProgressIndicator();
        }
        return ListView(
          children: snapshot.data
              .map(
                (note) => ListTile(
                  title: Text(note.body),
                ),
              )
              .toList(),
        );
      },
    );
  }
}

class InfoTab extends StatefulWidget {
  final NoteBloc bloc;

  InfoTab(this.bloc);

  @override
  _InfoTabState createState() => _InfoTabState();
}

class _InfoTabState extends State<InfoTab> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Column(
        children: [
          TextFormField(
            controller: _controller,
            onFieldSubmitted: (text) {
              widget.bloc.inSink.add(
                Note(
                  body: text,
                  state: NoteState.INSERT,
                ),
              );

              setState(() => _controller.clear());
            },
          ),
        ],
      ),
    );
  }
}
