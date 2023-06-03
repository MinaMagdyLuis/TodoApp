import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/shared/components/components.dart';
import 'package:sqflite/sqflite.dart';
import '../shared/todo_cubit/todo_cubit.dart';
import '../shared/todo_cubit/todo_states.dart';

class HomeLayout extends StatelessWidget {
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _timeTextEditingController = TextEditingController();
  TextEditingController _dateTextEditingController = TextEditingController();

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) {
        return TodoCubit()..onCreateDataBase();
      },
      child: BlocConsumer<TodoCubit, TodoState>(
        listener: (context, state) {
          if (state is AppInsertDataBaseState) {
            Navigator.pop(context);
          }
        },
        builder: (context, state) {
          TodoCubit cubit = TodoCubit.getObject(context);
          return Scaffold(
            key: _scaffoldKey,
            appBar: AppBar(
              backgroundColor: Colors.lightBlueAccent,
              title: Text(
                cubit.titles[cubit.currentIndex],
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                ),
              ),
            ),
            // body: tasks.length == 0
            //     ? Center(child: CircularProgressIndicator())
            //     :
            body: state is! AppLoadingDatabaseState
                ? PageView(
                    children: cubit.screens,
                    controller: PageController(initialPage: cubit.currentIndex),
                    onPageChanged: (index) {
                      cubit.setIndex(index);
                    },
                  )
                : Center(child: CircularProgressIndicator()),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                if (cubit.isBottomSheetShowing == false) {
                  _scaffoldKey.currentState!
                      .showBottomSheet(
                        (context) {
                          return Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  padding: EdgeInsetsDirectional.all(20),
                                  child: defaultFromField(
                                    validate: (p0) {
                                      if (p0!.isEmpty) {
                                        return 'Title must not be empty';
                                      }
                                    },
                                    textEditingController:
                                        _titleTextEditingController,
                                    onChanged: (p0) {},
                                    type: TextInputType.text,
                                    labelText: 'Task Title',
                                    prefix: Icons.title,
                                    onSubmit: (p0) {},
                                    suffixPressed: () {},
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.all(20),
                                  child: defaultFromField(
                                    validate: (p0) {
                                      if (p0!.isEmpty) {
                                        return 'Time must not be empty';
                                      }
                                    },
                                    textEditingController:
                                        _timeTextEditingController,
                                    onChanged: (p0) {},
                                    type: TextInputType.datetime,
                                    labelText: 'Timing Tapped',
                                    prefix: Icons.watch_later_outlined,
                                    onSubmit: (p0) {},
                                    suffixPressed: () {},
                                    onTap: () {
                                      showTimePicker(
                                        context: context,
                                        initialTime: TimeOfDay.fromDateTime(
                                          DateTime.now(),
                                        ),
                                      ).then((value) {
                                        _timeTextEditingController.text =
                                            value!.format(context).toString();
                                      });
                                    },
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsetsDirectional.all(20),
                                  child: defaultFromField(
                                    validate: (p0) {
                                      if (p0!.isEmpty) {
                                        return 'Date must not be empty';
                                      }
                                    },
                                    textEditingController:
                                        _dateTextEditingController,
                                    onChanged: (p0) {},
                                    type: TextInputType.datetime,
                                    labelText: 'Date Tapped',
                                    prefix: Icons.calendar_today,
                                    onSubmit: (p0) {},
                                    suffixPressed: () {},
                                    onTap: () {
                                      showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime.now()
                                                  .subtract(Duration(days: 0)),
                                              lastDate: DateTime(2100))
                                          .then((value) {
                                        DateTime? picker = value;
                                        _dateTextEditingController.text =
                                            '${picker!.day}' +
                                                ' / ${picker!.month}' +
                                                ' / ${picker!.year}';
                                      });
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      )
                      .closed
                      .then((value) {
                        cubit.onChangeBottomSheetState(
                            iconData: Icons.edit, isBottomSheetShowing: false);
                      });
                  cubit.onChangeBottomSheetState(
                      iconData: Icons.add, isBottomSheetShowing: true);
                } else {
                  if (_formKey.currentState!.validate()) {
                    cubit.insertDataBase(
                        time: _timeTextEditingController.text,
                        date: _dateTextEditingController.text,
                        title: _titleTextEditingController.text);
                  }
                }
              },
              child: Icon(
                cubit.iconData,
              ),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.menu),
                  label: 'Tasks',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.check_circle_outline),
                  label: 'Done',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.archive_outlined),
                  label: 'Archived',
                ),
              ],
              currentIndex: cubit.currentIndex,
              onTap: (value) {
                cubit.setIndex(value);
              },
            ),
          );
        },
      ),
    );
  }
}

// homeClass
