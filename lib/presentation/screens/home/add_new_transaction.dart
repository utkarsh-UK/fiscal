import 'package:flutter/material.dart';

class AddNewTransaction extends StatelessWidget {
  const AddNewTransaction({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        color: Colors.white,
        child: Text('Add Transaction Screen'),
      ),
    );
  }
}
