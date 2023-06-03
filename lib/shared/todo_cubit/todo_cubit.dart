import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:projects/modules/done_tasks/done_tasks.dart';
import 'package:projects/shared/constants.dart';

import 'package:projects/shared/todo_cubit/todo_states.dart';
import 'package:sqflite/sqflite.dart';

import '../../modules/archived_tasks/archived_tasks.dart';
import '../../modules/new_tasks/new_tasks.dart';

class TodoCubit extends Cubit<TodoState> {
  List<Map> newTasks = [];
  List<Map> doneTasks = [];
  List<Map> archiveTasks = [];

  TodoCubit() : super(TodoInitialState());

  static TodoCubit getObject(context) => BlocProvider.of(context);

  int currentIndex = 0;
  List<Widget> screens = [
    NewTasks(),
    DoneTasks(),
    ArchivedTasks(),
  ];
  List<String> titles = [
    'New tasks',
    'Done tasks',
    'Archived tasks',
  ];

  void setIndex(int index) {
    currentIndex = index;
    emit(AppChangeBottomNavState());
  }

  Database? database;

  void onCreateDataBase() {
    openDatabase(
      'todo.db',
      version: 1,
      onCreate: (database, version) {
        print('Database created ');
        database
            .execute(
                'CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT,title TEXT,time TEXT,date TEXT,status TEXT)')
            .then(
          (value) {
            print('table created');
          },
        ).catchError((error) {
          print('error in creating table ${error.toString()}');
        });
      },
      onOpen: (database) {},
    ).then((value) {
      database = value;
      getDataFromDatabase(database);
      emit(AppCreateDatabaseState());
    });
  } // onCreateDataBase

  Future insertDataBase({
    required String time,
    required String date,
    required String title,
  }) async {
    await database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO tasks (title,time,date,status) VALUES ("$title", "$time", "$date", "new")')
          .then((value) {
        emit(AppInsertDataBaseState());
        getDataFromDatabase(database);
        // .then((value) {
        //   emit(AppLoadingDatabaseState());
        //   newTasks = value;
        //   emit(AppGetDatabaseState());
        //   print(value);
        // });
        print('$value' + 'vales inserted successfully');
      }).catchError((error) {
        print('error has been ocured in inseting values' + error.toString());
      });
    });
  }

  void getDataFromDatabase(database) {
    newTasks = [];
    doneTasks = [];
    archiveTasks = [];
    database!.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        if (element['status'] == 'new') {
          newTasks.add(element);
        } else if (element['status'] == 'done') {
          doneTasks.add(element);
        } else if (element['status'] == 'archive') {
          archiveTasks.add(element);
        }
      });
      // tasks=value;
      // tasks.forEach((element) {
      //   print(element['status']);
      // });
      emit(AppGetDatabaseState());
    });
  }

  IconData iconData = Icons.edit;
  bool isBottomSheetShowing = false;

  void onChangeBottomSheetState(
      {required IconData iconData, required bool isBottomSheetShowing}) {
    this.iconData = iconData;
    this.isBottomSheetShowing = isBottomSheetShowing;
    emit(AppChangeBottomNavState());
  }

  void onUpdateStatus({required String status, required int id}) async {
    database!.rawUpdate('UPDATE tasks SET status = ? WHERE id = ? ',
        ['$status', id]).then((value) {
      getDataFromDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }

  void onDeleteTasks({required int id}) async {
    database!.rawUpdate('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFromDatabase(database);
      emit(AppDeleteDataBaseState());
    });
  }
}
