import 'package:flutter/material.dart';
import 'package:shared/widgets/text_widget.dart';

class OptionSectionWidget extends StatelessWidget {
  const OptionSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        textWidget('test'),
        textWidget('test'),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              Expanded(child: textWidget('test')),
              Expanded(child: textWidget('test')),
            ],
          ),
        )
      ],
    );
  }
}