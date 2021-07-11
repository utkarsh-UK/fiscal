import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionForm extends StatefulWidget {
  final Function(String, TransactionType, double, String, int, String, String) onSubmit;

  const TransactionForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;

  String _title = '';
  String _description = '';
  double _amount = 0.0;
  String _typeDropdownValue = 'EXPENSE';
  TransactionType _transactionType = TransactionType.EXPENSE;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
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
              validator: (title) => title!.trim().isEmpty ? 'Title cannot be null or empty' : null,
              onSaved: (title) => _title = title == null ? '' : title.trim(),
            ),
            const SizedBox(height: 16.0),
            InputTitle(title: 'Type:'),
            const SizedBox(height: 12.0),
            DropdownButtonFormField<String>(
              onChanged: (type) => setState(() => _typeDropdownValue = type ?? 'EXPENSE'),
              value: _typeDropdownValue,
              onSaved: (type) => _typeDropdownValue = type ?? 'EXPENSE',
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
              iconSize: 25.0,
              style: FiscalTheme.inputText,
              items: [
                DropdownMenuItem<String>(
                  value: 'EXPENSE',
                  child: Text('Expense'),
                ),
                DropdownMenuItem<String>(
                  value: 'INCOME',
                  child: Text('Income'),
                ),
              ],
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
              validator: (amount) {
                if (amount == null)
                  return 'Please enter valid positive amount';
                else if (amount.isEmpty)
                  return 'Amount cannot be empty';
                else if (double.parse(amount) <= 0.0)
                  return 'Amount cannot be null or negative';
                else
                  return null;
              },
              onSaved: (amount) => _amount = double.parse(amount == null ? '0.0' : amount.trim()),
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
              initialValue: DateFormat.MMMMd().format(DateTime.now()),
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
              textCapitalization: TextCapitalization.sentences,
              style: FiscalTheme.inputText,
              maxLength: 50,
              onSaved: (desc) => _description = desc == null ? '' : desc.trim(),
            ),
            const SizedBox(height: 25.0),
            SizedBox(
              width: size.width,
              child: Consumer<TransactionProvider>(
                builder: (context, provider, child) {
                  if (provider.status == TransactionStatus.LOADING)
                    return CircularProgressIndicator(key: ValueKey('progress'));
                  else if (provider.status == TransactionStatus.ERROR)
                    return ErrorWidget(provider.error);
                  else if (provider.status == TransactionStatus.COMPLETED)
                    return _onAddComplete(child!);
                  else
                    return child!;
                },
                child: TextButton(
                  key: ValueKey('save'),
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
    if (_formKey.currentState == null || !_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();
    _transactionType = Converters.convertTransactionTypeString(_typeDropdownValue);

    final String? result = _validateInputs(_title, _transactionType, _amount, _description);

    if (result != null) return;

    // call onSubmit
    widget.onSubmit(_title, _transactionType, _amount, '', 0, '', _description);
  }

  String? _validateInputs(String? title, TransactionType? type, double? amount, String? description) {
    if (title == null || title.isEmpty) return 'Title cannot be null or empty';
    if (type == null) return 'Transaction type cannot be null';
    if (amount == null || amount <= 0.0) return 'Amount cannot be null or negative';
    if (description == null) return 'Description cannot be null';

    return null;
  }

  Widget _onAddComplete(Widget child) {
    context.read<TransactionProvider>().getRecentTransactions().then((_) {
      context.read<TransactionProvider>().getDailySummary();
    });

    return child;
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
