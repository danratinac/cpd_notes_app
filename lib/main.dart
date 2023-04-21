import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => AppState(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF612940),
          ),
        ),
        home: const HomeScreen(),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var currentLabel = 0;

  void changeCurrentLabel(changeTo) {
    currentLabel = changeTo;
  }

  var labels = <String>[
    'Unlabeled',
    'Todo',
    'Work',
    'School',
    'Quotes',
    'Important',
    'Travel',
  ];

  String getCurrentLabel() {
    return labels[currentLabel];
  }

  var notes = <List<NoteData>>[
    [
      NoteData('Note 1',
          'This is the body of a note. No this is not real data it is just a placeholder. I wonder how long I need to make this to trigger overflow. I guess it needs to be longer than what I had before. You can clearly see this note is longer than the rest.'),
      NoteData('Note 2',
          'This is the body of a note. No this is not real data it is just a placeholder. I wonder how long I need to make this to trigger overflow'),
      NoteData('Note 3 has particularly long title',
          'This is the body of a note. No this is not real data it is just a placeholder. I wonder how long I need to make this to trigger overflow'),
    ],
    [],
    [],
    [],
    [],
    [],
    [],
  ];

  void addNote(title, text) {
    notes.elementAt(currentLabel).add(NoteData(title, text));
    notifyListeners();
  }
}

class NoteData {
  String title;
  String text;

  NoteData(this.title, this.text);
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTheme = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 35,
    );

    var appState = context.watch<AppState>();

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        body: SafeArea(
          child: TabBarView(
            children: appState.labels
                .map((e) => LabelPage(
                      titleTheme: titleTheme,
                      title: e,
                      labelIndex: appState.labels.indexOf(e),
                    ))
                .toList(),
          ),
        ),
        bottomNavigationBar: const LabelsAppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const NewNoteScreen()),
            );
          },
          tooltip: 'Add Note',
          child: const Icon(Icons.note_add_outlined),
        ),
      ),
    );
  }
}

class NewNoteScreen extends StatefulWidget {
  const NewNoteScreen({super.key});

  @override
  State<NewNoteScreen> createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final titleController = TextEditingController();
  final noteController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTheme = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.primary,
      fontSize: 35,
    );

    var appState = context.watch<AppState>();

    return DefaultTabController(
      length: 7,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'New Note',
                        style: titleTheme,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.close),
                      iconSize: 40.0,
                      tooltip: 'Cancel',
                    ),
                  ],
                ),
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(
                    label: Text('Note title...'),
                  ),
                ),
                Expanded(
                  child: TextField(
                    controller: noteController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                      label: Text('Take a note...'),
                      border: InputBorder.none,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            appState.addNote(titleController.text, noteController.text);
            Navigator.pop(context);
          },
          tooltip: 'Confirm',
          child: const Icon(Icons.check),
        ),
        bottomNavigationBar:
            const LabelsAppBarWithTitle(title: 'Select note label:'),
      ),
    );
  }
}

class LabelPage extends StatelessWidget {
  const LabelPage({
    super.key,
    required this.titleTheme,
    required this.title,
    required this.labelIndex,
  });

  final TextStyle titleTheme;
  final String title;
  final int labelIndex;

  @override
  Widget build(BuildContext context) {
    var appState = context.watch<AppState>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            '$title Notes',
            style: titleTheme,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: GridView.count(
              crossAxisCount: 2,
              children: [
                for (var i = appState.notes[labelIndex].length - 1; i >= 0; i--)
                  NoteDisplay(noteDataIndex: [labelIndex, i])
              ],
            ),
          ),
        )
      ],
    );
  }
}

class LabelsAppBar extends StatelessWidget {
  const LabelsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    var appState = context.watch<AppState>();

    return ColoredBox(
      color: theme.colorScheme.primary,
      child: TabBar(
        isScrollable: true,
        indicatorColor: theme.colorScheme.onPrimary,
        labelColor: theme.colorScheme.onPrimary,
        unselectedLabelColor: theme.colorScheme.inversePrimary,
        onTap: (value) => appState.changeCurrentLabel(value),
        tabs: const [
          Tab(
            icon: Icon(Icons.label_off_outlined),
            text: "Unlabeled",
          ),
          Tab(
            icon: Icon(Icons.checklist_outlined),
            text: "Todo",
          ),
          Tab(
            icon: Icon(Icons.work_outline),
            text: "Work",
          ),
          Tab(
            icon: Icon(Icons.school_outlined),
            text: "School",
          ),
          Tab(
            icon: Icon(Icons.chat_bubble_outline),
            text: "Quotes",
          ),
          Tab(
            icon: Icon(Icons.report_outlined),
            text: "Important",
          ),
          Tab(
            icon: Icon(Icons.airplanemode_active_outlined),
            text: "Travel",
          ),
        ],
      ),
    );
  }
}

class LabelsAppBarWithTitle extends StatelessWidget {
  const LabelsAppBarWithTitle({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme.titleMedium!.copyWith(
      color: theme.colorScheme.onPrimary,
    );

    var appState = context.watch<AppState>();

    return ColoredBox(
      color: theme.colorScheme.primary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              title,
              style: textTheme,
            ),
          ),
          TabBar(
            isScrollable: true,
            indicatorColor: theme.colorScheme.onPrimary,
            labelColor: theme.colorScheme.onPrimary,
            unselectedLabelColor: theme.colorScheme.inversePrimary,
            onTap: (value) => appState.changeCurrentLabel(value),
            tabs: const [
              Tab(
                icon: Icon(Icons.label_off_outlined),
                text: "Unlabeled",
              ),
              Tab(
                icon: Icon(Icons.checklist_outlined),
                text: "Todo",
              ),
              Tab(
                icon: Icon(Icons.work_outline),
                text: "Work",
              ),
              Tab(
                icon: Icon(Icons.school_outlined),
                text: "School",
              ),
              Tab(
                icon: Icon(Icons.chat_bubble_outline),
                text: "Quotes",
              ),
              Tab(
                icon: Icon(Icons.report_outlined),
                text: "Important",
              ),
              Tab(
                icon: Icon(Icons.airplanemode_active_outlined),
                text: "Travel",
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class NoteDisplay extends StatelessWidget {
  const NoteDisplay({super.key, required this.noteDataIndex});

  final List<int> noteDataIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final titleTheme = theme.textTheme.titleLarge!.copyWith(
      color: theme.colorScheme.primary,
    );
    final textTheme = theme.textTheme.bodyMedium;

    var appState = context.watch<AppState>();

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Card(
        color: theme.colorScheme.primaryContainer,
        shadowColor: theme.colorScheme.primary,
        elevation: 5.0,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(
                  appState.notes[noteDataIndex[0]][noteDataIndex[1]].title,
                  style: titleTheme,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Expanded(
                child: Text(
                  appState.notes[noteDataIndex[0]][noteDataIndex[1]].text,
                  style: textTheme,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 8,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
