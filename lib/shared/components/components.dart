import 'package:flutter/material.dart';
import 'package:projects/shared/todo_cubit/todo_cubit.dart';

Widget defaultFromField({
  required String? Function(String?)? validate,
  bool isPassword = false,
  required TextEditingController textEditingController,
  String? Function(String?)? onChanged,
  required TextInputType type,
  IconData? suffix,
  required String labelText,
  required IconData prefix,
  required String? Function(String?)? onSubmit,
  VoidCallback? suffixPressed,
  VoidCallback? onTap,
}) =>
    TextFormField(
      validator: validate,
      obscureText: isPassword,
      controller: textEditingController,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: Colors.black, fontSize: 20),
        suffixIcon: suffix != null
            ? IconButton(
                icon: Icon(suffix),
                onPressed: suffixPressed,
              )
            : null,
        prefixIcon: Icon(
          prefix,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(13),
          borderSide: BorderSide(color: Colors.blueGrey),
        ),
      ),
      keyboardType: type,
      onFieldSubmitted: onSubmit,
      onTap: onTap,
    );

Widget buildTaskItem(
    {required String time,
    required String title,
    required String date,
    required int id,
    required context}) {
  bool isDismissible = false;
  return Dismissible(
    key: Key(id.toString()),
    child: Card(
      elevation: 8.0,
      child: ListTile(
        leading: Container(
          padding: EdgeInsets.only(right: 5),
          decoration: BoxDecoration(
            border: Border(
              right: BorderSide(width: 1.0),
            ),
          ),
          child: Text(time,
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              maxLines: 1),
        ),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          date,
          style: TextStyle(fontSize: 16),
          maxLines: 1,
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.check_box_outlined),
              onPressed: () {
                TodoCubit.getObject(context)
                    .onUpdateStatus(status: 'done', id: id);

                // Handle edit button press
              },
            ),
            IconButton(
              icon: Icon(Icons.unarchive_outlined),
              onPressed: () {
                TodoCubit.getObject(context)
                    .onUpdateStatus(status: 'archive', id: id);
              },
            ),
          ],
        ),
      ),
    ),
    confirmDismiss: (direction) {
      return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.delete,
                    color: Colors.blue,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    'Delete Task !',
                    style: TextStyle(
                        color: Colors.blue,
                        fontStyle: FontStyle.italic,
                        fontSize: 20),
                  ),
                )
              ],
            ),
            content: Text(
              'Do you want to delete that task',
              style: TextStyle(
                  color: Colors.black,
                  fontStyle: FontStyle.italic,
                  fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                  // Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: Text(
                  'cancel',
                  style: TextStyle(
                      color: Colors.blue,
                      fontStyle: FontStyle.italic,
                      fontSize: 20),
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                 isDismissible=true;
                },
                child: Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );
    },
    onDismissed: (direction) {
      if(isDismissible==true){
        TodoCubit.getObject(context).onDeleteTasks(id: id);
      }
    },
  );
}
