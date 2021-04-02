import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveRaisedButton extends StatelessWidget {
  final Function submitDataHandler;
  final String buttonText;

  AdaptiveRaisedButton({
    @required this.buttonText,
    @required this.submitDataHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Platform.isIOS
          ? CupertinoButton.filled(
              child: Text(buttonText),
              onPressed: () => submitDataHandler(context),
            )
          : ElevatedButton(
              onPressed: () => submitDataHandler(context),
              child: Text(buttonText),
            ),
    );
  }
}
