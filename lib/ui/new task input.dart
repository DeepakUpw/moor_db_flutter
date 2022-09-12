
import 'package:flutter/material.dart';
import 'package:moor_db_flutter/data/app_database.dart';
import 'package:provider/provider.dart';

class NewTaskInput extends StatefulWidget {
  const NewTaskInput({Key? key}) : super(key: key);

  @override
  State<NewTaskInput> createState() => _NewTaskInputState();
}

class _NewTaskInputState extends State<NewTaskInput> {
  DateTime? newTaskDate;
  late TextEditingController textController;

  @override
  void initState() {
    super.initState();
    textController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildTextField(context),
          _buildDateButton(context),
        ],
      ),
    );
  }

  Expanded _buildTextField(BuildContext context) {
    return Expanded(
        child: TextField(
      controller: textController,
      decoration: InputDecoration(hintText: 'Task Name'),
      onSubmitted: (inputName) {
        final database = Provider.of<AppDatabase>(context,listen: false);
        final task = Task(name: inputName,dueDate: newTaskDate);
        database.insertTask(task);
        resetValuesAfterSubmit();
      },
    ));
  }

  IconButton _buildDateButton(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.calendar_today),
      onPressed: () async {
        newTaskDate = (await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2022),
            lastDate: DateTime(2050)))!;
      },
    );
  }

  void resetValuesAfterSubmit() {
    newTaskDate = null;
    textController.clear();
    setState(() {
    });

  }

}
