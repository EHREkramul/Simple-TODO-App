import 'package:flutter/material.dart';

class TODO extends StatefulWidget {
  const TODO({super.key});

  @override
  State<TODO> createState() => _TODOState();
}

class _TODOState extends State<TODO> {
  final List<Map<String, dynamic>> _tasks = [];
  bool _showActiveTask = true;

  void _addTask(String task) {
    setState(() {
      _tasks.add({"task": task, "status": false});
    });
  }

  void _toggleTaskStatus(int index) {
    if (index < 0 || index >= _tasks.length) return;

    setState(() {
      _tasks[index]['status'] = !_tasks[index]['status'];
    });
  }

  void _deleteTask(int index) {
    if (index < 0 || index >= _tasks.length) return;

    setState(() {
      _tasks.removeAt(index);
    });
  }

  void _showTaskDialogue({int? index}) {
    TextEditingController taskController = TextEditingController(
      text: index != null ? _tasks[index]['task'] : '',
    );

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: Text(index == null ? 'Add New Task' : 'Edit Task'),
            content: TextField(
              controller: taskController,
              autofocus: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Task Name',
                hintText: 'Enter Task Name',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  if (index == null) {
                    _addTask(taskController.text);
                  } else {
                    _editTask(index, taskController.text);
                  }
                  taskController.clear();
                  Navigator.of(context).pop();
                },
                child: Text(index == null ? 'Add' : 'Save Changes'),
              ),
            ],
          ),
    );
  }

  void _editTask(index, String updatedTask) {
    setState(() {
      _tasks[index]['task'] = updatedTask;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TODO List'),
        centerTitle: true,
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showTaskDialogue(),
        shape: CircleBorder(),
        backgroundColor: Colors.blue,
        child: Icon(Icons.add_task_outlined, color: Colors.white),
      ),
      body: Column(
        children: [
          Container(
            height: 220,
            width: double.infinity,
            color: Colors.white,
            child: Column(
              children: [
                Card(
                  elevation: 10,
                  color: Colors.blueGrey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: SizedBox(
                    height: 50,
                    child: Center(
                      child: Text(
                        'Total Task:  ${_tasks.length}',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 10,
                        color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: 150,
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  'Active Task',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  _tasks
                                      .where((task) => !task['status'])
                                      .length
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 10,
                        color: Colors.blueGrey,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: SizedBox(
                          height: 150,
                          child: Center(
                            child: Column(
                              children: [
                                SizedBox(height: 15),
                                Text(
                                  'Completed Task',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 15),
                                Text(
                                  _tasks
                                      .where((task) => task['status'])
                                      .length
                                      .toString(),
                                  style: TextStyle(
                                    fontSize: 40,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.greenAccent,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder:
                  (context, index) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 5,
                      left: 5,
                      right: 5,
                    ),
                    child: Dismissible(
                      key: Key(UniqueKey().toString()),
                      background: Container(
                        color: Colors.green,
                        padding: EdgeInsets.only(left: 15),
                        alignment: Alignment.centerLeft,
                        child: Icon(Icons.done, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        color: Colors.redAccent,
                        padding: EdgeInsets.only(right: 15),
                        alignment: Alignment.centerRight,
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        if (direction == DismissDirection.startToEnd) {
                          _toggleTaskStatus(index);
                        } else {
                          _deleteTask(index);
                        }
                      },
                      child: ListTile(
                        onLongPress: () => _showTaskDialogue(index: index),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        leading: Checkbox(
                          value: _tasks[index]['status'],
                          onChanged: (value) => _toggleTaskStatus(index),
                        ),
                        title: Text(_tasks[index]['task']),
                        // subtitle: Text('Subtitle here'),
                        tileColor: Colors.grey.shade300,
                        trailing: Text(
                          _tasks[index]['status'] ? 'Completed' : 'Active',
                          style: TextStyle(
                            color:
                                _tasks[index]['status']
                                    ? Colors.green
                                    : Colors.blueAccent,
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
