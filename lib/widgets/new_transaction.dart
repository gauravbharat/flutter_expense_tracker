import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NewTransaction extends StatefulWidget {
  final Function newTxHandler;

  NewTransaction({@required this.newTxHandler});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();

  final amountController = TextEditingController();

  void submitData(BuildContext ctx) {
    try {
      final enteredTitle = titleController.text;
      final enteredAmount = double.parse(amountController.text);

      if (enteredTitle.isEmpty || enteredAmount <= 0) {
        return;
      }

      widget.newTxHandler(
        enteredTitle,
        enteredAmount,
      );
    } on FormatException {
      // do nothing
    }

    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                // onSubmitted: (_) => submitData(),
              ),
              TextField(
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d*)'))
                ],
                controller: amountController,
                decoration: InputDecoration(
                  labelText: 'Amount',
                ),
                // onSubmitted: (_) => submitData(),
              ),
              TextButton(
                onPressed: () => submitData(context),
                child: Text('Add Transaction'),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.purple)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
