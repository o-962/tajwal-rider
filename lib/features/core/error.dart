import 'package:flutter/material.dart';
import 'package:shared/widgets/text_widget.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: textWidget('The app crashed during initialization , close app and try again later :('),
      ),
    );
  }
}