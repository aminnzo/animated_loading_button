import 'dart:async';

import 'package:animated_loading_button/animated_loading_button.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoadingButtonController _controller = LoadingButtonController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          LoadingButton(
            child: const Text('Tap me!', style: TextStyle(color: Colors.white)),
            controller: _controller,
            onPressed: _doSomething,
          )
        ],
      ),
    );
  }

  void _doSomething() async {
    Timer(Duration(seconds: 2), () {
      _controller.success();
    });
  }
}
