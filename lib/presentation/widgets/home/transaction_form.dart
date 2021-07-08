import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionForm extends StatefulWidget {
  final Function onSubmit;

  const TransactionForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _transactionTypeController;

  String _title = '';
  String _description = '';
  double _amount = 0.0;
  TransactionType _transactionType = TransactionType.EXPENSE;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _transactionTypeController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _transactionTypeController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputTitle(title: 'Title:'),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _titleController,
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
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16.0),
            InputTitle(title: 'Type:'),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _transactionTypeController,
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
              keyboardType: TextInputType.text,
              textCapitalization: TextCapitalization.characters,
            ),
            const SizedBox(height: 16.0),
            InputTitle(title: 'Amount:'),
            const SizedBox(height: 12.0),
            TextFormField(
              controller: _amountController,
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
              controller: _descriptionController,
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
              child: Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  if (provider.status == TransactionStatus.LOADING)
                    return CircularProgressIndicator();
                  else if (provider.status == TransactionStatus.ERROR)
                    return ErrorWidget(provider.error);
                  else
                    return child!;
                },
                child: TextButton(
                  onPressed: _save,
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
            ),
          ],
        ),
      ),
    );
  }

  void _save() {
    _title = _titleController.text.trim();
    _transactionType = Converters.convertTransactionTypeString(_transactionTypeController.text.trim());
    _amount = double.parse(_amountController.text.trim());
    _description = _descriptionController.text.trim();

    final String? result = _validateInputs(_title, _transactionType, _amount, _description);

    if (result != null) return;

    context.read<TransactionProvider>().addNewTransaction(
          title: _title,
          amount: _amount,
          type: _transactionType,
          categoryID: '',
          accountID: 0,
          date: DateTime.now(),
          description: _descriptionController.text.trim(),
        );
  }

  String? _validateInputs(String? title, TransactionType? type, double? amount, String? description) {
    if (title == null || title.isEmpty) return 'Title cannot be null or empty';
    if (type == null) return 'Transaction type cannot be null';
    if (amount == null || amount <= 0.0) return 'Amount cannot be null or negative';
    if (description == null) return 'Description cannot be null';

    return null;
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
