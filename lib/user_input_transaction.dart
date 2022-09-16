import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class user_input_transaction extends StatefulWidget {
  final Function add_item;
  user_input_transaction(this.add_item);

  @override
  State<user_input_transaction> createState() => _user_input_transactionState();
}

class _user_input_transactionState extends State<user_input_transaction> {
  final input_title = TextEditingController();

  final input_amount = TextEditingController();

  DateTime? PickedDate;

  void submit_data() {
    if (input_amount.text.isEmpty)
      return;
    else if (input_title.text.isEmpty ||
        double.parse(input_amount.text) <= 0 ||
        PickedDate == null) {
      return;
    }
    widget.add_item(
        input_title.text, double.parse(input_amount.text), PickedDate);
    Navigator.of(context).pop();
  }

  void show_date_picker() {
    showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(DateTime.now().year),
            lastDate: DateTime.now())
        .then((pickedDate) {
      if (pickedDate == null) return;
      setState(() {
        PickedDate = pickedDate;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
              left: 10,
              right: 10,
              top: 10,
              bottom: MediaQuery.of(context).viewInsets.bottom + 10),
          child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            TextField(
              decoration: InputDecoration(labelText: 'Title'),
              controller: input_title,
              onSubmitted: (_) {
                submit_data();
              },
            ),
            TextField(
              decoration: InputDecoration(labelText: 'Amount'),
              controller: input_amount,
              keyboardType: TextInputType.number,
              onSubmitted: (_) {
                submit_data();
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: Text(PickedDate == null
                      ? "No Chosed Date !"
                      : 'Picked Date : ${DateFormat.yMd().format(PickedDate!)}'),
                ),
                const SizedBox(
                  width: 10,
                ),
                TextButton(
                    onPressed: () {
                      show_date_picker();
                    },
                    child: const Text(
                      "Pick Date",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ))
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            ElevatedButton(
                child: const Text("Add Transaction",
                    style: TextStyle(fontWeight: FontWeight.bold)),
                onPressed: () {
                  submit_data();
                })
          ]),
        ),
      ),
    );
  }
}
