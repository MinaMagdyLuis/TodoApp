import 'package:flutter/material.dart';

class endDrawer extends StatelessWidget {
  const endDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Text('mina'),
        ],
      ),
    );
  }
}
