import 'package:fiscal/core/core.dart';
import 'package:flutter/material.dart';

class TransactionForm extends StatefulWidget {
  final Function onSubmit;

  const TransactionForm({Key? key, required this.onSubmit }) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InputTitle(title: 'Title:'),
          const SizedBox(height: 12.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            ),
            style: FiscalTheme.inputText,
          ),
          const SizedBox(height: 16.0),
          InputTitle(title: 'Type:'),
          const SizedBox(height: 12.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            ),
            style: FiscalTheme.inputText,
          ),
          const SizedBox(height: 16.0),
          InputTitle(title: 'Amount:'),
          const SizedBox(height: 12.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            ),
            keyboardType: TextInputType.numberWithOptions(decimal: true),
            style: FiscalTheme.inputText,
          ),
          const SizedBox(height: 16.0),
          InputTitle(title: 'Category:'),
          const SizedBox(height: 12.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            style: FiscalTheme.inputText,
          ),
          const SizedBox(height: 16.0),
          InputTitle(title: 'Account:'),
          const SizedBox(height: 12.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16.0),
          InputTitle(title: 'Date:'),
          const SizedBox(height: 12.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            ),
            keyboardType: TextInputType.text,
          ),
          const SizedBox(height: 16.0),
          InputTitle(title: 'Description:'),
          const SizedBox(height: 12.0),
          TextFormField(
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              counterText: '',
              fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
              filled: true,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            ),
            keyboardType: TextInputType.text,
            textCapitalization: TextCapitalization.words,
            style: FiscalTheme.inputText,
            maxLength: 50,
          ),
          const SizedBox(height: 25.0),
          SizedBox(
            key: ValueKey('save'),
            width: size.width,
            child: TextButton(
              onPressed: () => widget.onSubmit(),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(FiscalTheme.SECONDARY_COLOR),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 10.0)),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0))),
                elevation: MaterialStateProperty.all(4.0),
              ),
              child: Text(
                'Save',
                style: FiscalTheme.bodyWhiteText.copyWith(color: Color(0xFFFFFFFF)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class InputTitle extends StatelessWidget {
  final String title;

  const InputTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: FiscalTheme.screenTitleText.copyWith(fontSize: 18.0));
  }
}
