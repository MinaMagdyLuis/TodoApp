import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects/layout/home_layout.dart';
import 'package:projects/screens/bmi_calculator.dart';
import 'package:projects/screens/form.dart';
import 'package:projects/shared/bloc_observer.dart';
import 'package:projects/shared/drawer.dart';


void main() {
Bloc.observer= const AppBlocObserver();
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: HomeLayout(

      ),
    );
  }
}
