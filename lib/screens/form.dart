import 'package:flutter/material.dart';

class FormScreen extends StatefulWidget {
  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  bool _obsecureText = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              obscureText: _obsecureText,
              decoration: InputDecoration(
                  labelText: 'mmmmmm',
                  suffix: IconButton(onPressed: () {

                    setState(() {
                      _obsecureText=!_obsecureText;
                    });
                  },
                      icon: Icon(Icons.remove_red_eye)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(13))),
            )
          ],
        ),
      ),
    );
  }
}
