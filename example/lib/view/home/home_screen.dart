import 'package:calendar_manager_example/presentation/main_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MainViewModel(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: HomeScreenContent(),
      ),
    );
  }
}

class HomeScreenContent extends StatelessWidget {
  Widget buildLoading() {
    return Center(
        child: CircularProgressIndicator(
      key: Key("loading"),
    ));
  }

  Widget createButton(String name, VoidCallback onPressed) {
    return ElevatedButton(
      key: Key(name.replaceAll(" ", "")),
      onPressed: onPressed,
      child: Text(name),
    );
  }

  @override
  Widget build(BuildContext context) {
    final MainViewModel viewModel = Provider.of(context);
    assert(viewModel != null);
    assert(viewModel.isLoading != null);
    if (viewModel.isLoading) {
      return buildLoading();
    }
    return Center(
      child: Column(
        children: <Widget>[
          createButton("Create Event", viewModel.onCreateEventClick),
          createButton("Delete Calendar", viewModel.onDeleteCalendarClick),
          createButton("Create Calendar", viewModel.onCreateCalendarClick),
          createButton('Cause Crash', viewModel.onCauseCrashClick),
          createButton('Delete All Events ', viewModel.onDeleteAllEventsClick),
        ],
      ),
    );
  }
}
