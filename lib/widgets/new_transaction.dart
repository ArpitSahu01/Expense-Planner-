
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
class NewTransaction extends StatefulWidget {

  final Function addTx;
  NewTransaction(this.addTx){
    print('Constructor NewTransaction Widget');
  }

  @override
  _NewTransactionState createState()  {
    print('createState NewTransaction Widget');
    return _NewTransactionState();
  }

}

class _NewTransactionState extends State<NewTransaction>{
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;

  _NewTransactionState(){
    print('Constructor NewTransaction State');
}

@override
  void initState() {
      print('initState()');
    super.initState();
  }

  @override
  void didUpdateWidget(covariant NewTransaction oldWidget) {
    print('didUpdateWidget()');
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {

    print("dispose()");
    super.dispose();

  }

  void _onSubmit(){
    if(_amountController.text.isEmpty){
      return;
    }
    final enteredTitle = _titleController.text;
    final enteredAmount = double.parse(_amountController.text);

    if(enteredTitle.isEmpty || enteredAmount<=0 || _selectedDate == null){
      return;
    }

    widget.addTx(
      enteredTitle,
      enteredAmount,
      _selectedDate,
    );
    Navigator.of(context).pop();

  }

  void _presentDatePicker(){
    showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2021),
        lastDate: DateTime.now()
    ).then((pickedDate){
      if(pickedDate == null){
        return;
      }
      setState((){
        _selectedDate = pickedDate;
      });

    });
  }

 @override
  Widget build(BuildContext context){
    print('build() New_Transaction');
   final mediaQuery = MediaQuery.of(context);

    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Container(
          padding: EdgeInsets.only(
            top: 10,
            left: 10,
            right: 10,
            bottom: mediaQuery.viewInsets.bottom + 10,
          ),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextField(
                decoration: InputDecoration(labelText: 'Title'),
                controller: _titleController,
                // onChanged: (val)=> titleInput=val,
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Amount'),
                controller: _amountController,
                keyboardType: TextInputType.number,
                // onChanged: (val)=> amountInput=val,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_selectedDate == null ?'No Date Chosen!': 'Picked date: ${DateFormat.yMd().format(_selectedDate as DateTime)}'),
                  TextButton(
                    onPressed: _presentDatePicker,
                    child: Text(' Choose Date',style: TextStyle(fontWeight: FontWeight.bold)),
                    //style: ButtonStyle(foregroundColor: MaterialStateProperty.all(Theme.of(context).primaryColor)),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              ElevatedButton(
                onPressed: _onSubmit,
                child: Text('Add Transaction'),
                style: ElevatedButton.styleFrom(
                    foregroundColor: Theme.of(context).textTheme.button?.color,
                    backgroundColor: Theme.of(context).primaryColor,
                    textStyle: TextStyle(fontSize: 20,
                      fontWeight: FontWeight.bold,)
                ),

              ),
            ],
          ),
        ),
      ),
    );
  }
}