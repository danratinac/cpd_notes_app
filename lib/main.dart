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
        home: const DefaultTabController(
          length: 7,
          child: HomeScreen(),
        ),
      ),
    );
  }
}

class AppState extends ChangeNotifier {
  var currentLabel = 0;

  void changeCurrentLabel(changeTo) {
    currentLabel = changeTo;
    print('new value is: $currentLabel');
  }

  var labels = <String>[
    'Unlabeled',
    'Todo',
    'Work',
    'School',
    'Quotes',
    'Important',
    'Travel'
  ];

  String getCurrentLabel() {
    return labels[currentLabel];
  }
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

    return Scaffold(
      body: SafeArea(
        child: TabBarView(
          children: appState.labels
              .map((e) => Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      '$e Notes',
                      style: titleTheme,
                    ),
                  ))
              .toList(),
        ),
      ),
      bottomNavigationBar: const _LabelsAppBar(),
      floatingActionButton: const FloatingActionButton(
        onPressed: null,
        tooltip: 'Add Note',
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }
}

class _LabelsAppBar extends StatelessWidget {
  const _LabelsAppBar({super.key});

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
