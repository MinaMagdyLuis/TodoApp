import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/shared/todo_cubit/todo_cubit.dart';
import 'package:projects/shared/todo_cubit/todo_states.dart';
import '../../shared/components/components.dart';

class ArchivedTasks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TodoCubit, TodoState>(
      listener: (context, state) {},
      builder: (context, state) {
        var tasks = TodoCubit.getObject(context).archiveTasks;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: tasks.length <= 0
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu, size: 35),
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Text(
                          'No archived tasks yet , Please add a task',
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      )
                    ],
                  ),
                )
              : ListView.separated(
                  itemBuilder: (context, index) {
                    return buildTaskItem(
                      time: tasks[index]['time'],
                      date: tasks[index]['date'],
                      title: tasks[index]['title'],
                      context: context,
                      id: tasks[index]['id'],
                    );
                  },
                  separatorBuilder: (context, index) {
                    return Container(
                      height: 3,
                      color: Colors.white,
                    );
                  },
                  itemCount: tasks.length),
        );
      },
    );
  }
}
