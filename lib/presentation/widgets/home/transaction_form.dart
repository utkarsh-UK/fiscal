import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionForm extends StatefulWidget {
  final Function(String, TransactionType, double, String, int, DateTime, String) onSubmit;

  const TransactionForm({Key? key, required this.onSubmit}) : super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;

  String _title = '';
  String _description = '';
  double _amount = 0.0;
  String _typeDropdownValue = 'EXPENSE';
  DateTime _transactionDate = DateTime.now();
  String formattedDate = '';
  TransactionType _transactionType = TransactionType.EXPENSE;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _dateController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _descriptionController.dispose();
    _amountController.dispose();
    _dateController.dispose();
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
              validator: (title) => title!.trim().isEmpty ? 'Please provide title for transaction' : null,
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
                  return 'Amount is mandatory';
                else if (double.parse(amount) <= 0.0)
                  return 'Amount cannot be negative';
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
              controller: _dateController,
              showCursor: false,
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
                suffixIcon: IconButton(
                  onPressed: _handleDateSelector,
                  icon: Icon(
                    Icons.calendar_today_rounded,
                    color: Color(0xFF57335D),
                  ),
                ),
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

    final bool result = _validateInputs(_title, _transactionType, _amount, _description);

    if (!result) return;

    // call onSubmit
    widget.onSubmit(_title, _transactionType, _amount, '', 0, _transactionDate, _description);
  }

  bool _validateInputs(String? title, TransactionType? type, double? amount, String? description) {
    if (title == null || title.isEmpty) return false;
    if (type == null) return false;
    if (amount == null || amount <= 0.0) return false;
    if (description == null) return false;

    return true;
  }

  Widget _onAddComplete(Widget child) {
    _clearInputs();
    context.read<TransactionProvider>().getRecentTransactions().then((_) {
      context.read<TransactionProvider>().getDailySummary();
    });

    return child;
  }

  Future<void> _handleDateSelector() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 365)),
      lastDate: DateTime.now().add(Duration(days: 1)),
    );

    // Cancelled the date selector
    if (date == null) return;

    // User has selected date. Show time picker
    final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    // Cancelled the time picker
    if (time == null) return;

    // User has selected time. Build actual transaction time
    final transDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    _dateController.text = transDate.getFullStringDate;
    setState(() => _transactionDate = transDate);
  }

  void _clearInputs() {
    _titleController.clear();
    _amountController.clear();
    _dateController.clear();
    _descriptionController.clear();
    setState(() {});
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
