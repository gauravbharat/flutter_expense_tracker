import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveTextButton extends StatelessWidget {
  final Function datePickerHandler;
  final String buttonText;

  AdaptiveTextButton({
    @required this.buttonText,
    @required this.datePickerHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Platform.isIOS
        ? CupertinoButton(
            child: Text(buttonText),
            onPressed: () {
              datePickerHandler(context);
            })
        : TextButton(
            onPressed: () {
              datePickerHandler(context);
            },
            child: Text(buttonText),
          );
  }
}
