import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class NewTransaction extends StatefulWidget {
  final Function newTxHandler;

  NewTransaction({@required this.newTxHandler});

  @override
  _NewTransactionState createState() => _NewTransactionState();
}

class _NewTransactionState extends State<NewTransaction> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  void _submitData(BuildContext ctx) {
    try {
      final enteredTitle = titleController.text;
      final enteredAmount = double.parse(amountController.text);

      if (enteredTitle.isEmpty || enteredAmount <= 0 || _selectedDate == null) {
        return;
      }

      widget.newTxHandler(
        enteredTitle,
        enteredAmount,
        _selectedDate,
      );
    } on FormatException {
      // do nothing
    }

    Navigator.pop(ctx);
  }

  void _presentDatePicker(BuildContext ctx) {
    showDatePicker(
      context: ctx,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    ).then((pickedDate) {
      if (pickedDate == null) {
        return;
      }

      setState(() {
        _selectedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5.0,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            // When a mobile device's keyboard is visible viewInsets.bottom corresponds to the top of the keyboard
            // bottom: MediaQuery.of(context).viewInsets.bottom + 10,

            // setting 'isScrollControlled: true' in the showModalBottomSheet, lifted up the bottom sheet above the soft keyboard
            bottom: 10,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                controller: titleController,
                maxLength: 25,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
                // onSubmitted: (_) => _submitData(),
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
                // onSubmitted: (_) => _submitData(),
              ),
              Container(
                height: 70.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_selectedDate == null
                        ? 'No Date Chosen!'
                        : 'Picked Date: ${DateFormat.yMd().format(_selectedDate)}'),
                    TextButton(
                      onPressed: () {
                        _presentDatePicker(context);
                      },
                      child: Text('Choose Date'),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _submitData(context),
                  child: Text('Add Transaction'),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
