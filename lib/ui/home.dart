
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:moor_db_flutter/data/app_database.dart';
import 'package:provider/provider.dart';
import 'new task input.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(child: _buildTaskList(context)),
            NewTaskInput(),
          ],
        ),
      ),
    );
  }
}

StreamBuilder<List<Task>> _buildTaskList(BuildContext context) {
  final database = Provider.of<AppDatabase>(context,listen: false);

  return StreamBuilder(
    stream: database.watchAllTasks(),
    builder: (context, AsyncSnapshot<List<Task>> snapshot) {
      final tasks = snapshot.data ?? [];
      return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (_, index) {
            final itemTask = tasks[index];
            return _buildListItem(itemTask, database);
          }
      );
    },
  );
}

Widget _buildListItem(Task itemTask, AppDatabase database) {
  return Slidable(
    // Specify a key if the
    // Liable is dismissible.
    endActionPane: ActionPane(
      motion: ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (BuildContext context){
            database.deleteTask(itemTask);
          },
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
        SlidableAction(
          onPressed: (BuildContext context){

          },
          backgroundColor: Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.minimize_outlined,
          label: 'Close Slide',
        ),
      ],

    ),
    child: CheckboxListTile(
      title: Text(itemTask.name),
      subtitle: Text(itemTask.dueDate?.toString() ?? 'No date'),
      value: itemTask.completed,
      onChanged: (newValue) {
        database.updateTask(itemTask.copyWith(completed: newValue));
      },
    ),
  );
}



