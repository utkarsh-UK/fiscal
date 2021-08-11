import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/core/category.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/core/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionForm extends StatefulWidget {
  final Function(String, String, TransactionType, double, int, int, DateTime, String, String, String, String, int) onSubmit;
  final bool isUpdateState;
  final Transaction? transaction;

  /// [onSubmit] Parameters :- (ID, Title, TransactionType, Amount, CategoryID, AccountID, Date, Description, Category Icon,
  /// Category, Color, BankName, AccountNumber).
  ///
  /// If [isUpdateState] is true, [transaction] parameter must not be null.
  /// Else empty transaction object will be passed to prevent runtime exceptions.
  const TransactionForm({
    Key? key,
    required this.onSubmit,
    this.isUpdateState = false,
    this.transaction,
  })  : assert(isUpdateState ? transaction != null : true),
        super(key: key);

  @override
  _TransactionFormState createState() => _TransactionFormState();
}

class _TransactionFormState extends State<TransactionForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _dateController;

  List<Category> _categories = [];
  List<Account> _accounts = [];

  String _title = '';
  String _description = '';
  double _amount = 0.0;
  String _typeDropdownValue = 'EXPENSE';
  int _categoryDropdownValue = -1;
  int _accountDropdownValue = -1;
  DateTime _transactionDate = DateTime.now();
  TransactionType _transactionType = TransactionType.EXPENSE;

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _amountController = TextEditingController();
    _dateController = TextEditingController();

    if (widget.isUpdateState && widget.transaction != null) {
      _titleController.text = widget.transaction!.title;
      _descriptionController.text = widget.transaction!.description ?? '';
      _amountController.text = widget.transaction!.amount.toString();
      _dateController.text = widget.transaction!.date.getFullStringDate;
      _typeDropdownValue = Converters.convertTransactionTypeEnum(widget.transaction!.transactionType);
      _transactionDate = widget.transaction!.date;
    }

    final type =
        widget.isUpdateState && widget.transaction != null ? widget.transaction!.transactionType : TransactionType.EXPENSE;
    Future.wait<List<Object>>(
            [context.read<TransactionProvider>().getCategories(type), context.read<TransactionProvider>().getAccounts()])
        .then((results) {
      final fetchedCat = results.first as List<Category>;
      final fetchedAcc = results[1] as List<Account>;
      _categoryDropdownValue =
          widget.isUpdateState && widget.transaction != null ? widget.transaction!.categoryID : fetchedCat.first.categoryID;
      _accountDropdownValue =
          widget.isUpdateState && widget.transaction != null ? widget.transaction!.accountID : fetchedAcc.first.accountID;
      _categories = fetchedCat;
      setState(() => _accounts = fetchedAcc);
    });
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
        key: ValueKey('scroller'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InputTitle(title: 'Title:'),
            const SizedBox(height: 12.0),
            TextFormField(
              key: ValueKey('trans_title'),
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
            SizedBox(
              width: size.width * 0.9,
              child: DropdownButtonFormField<String>(
                key: ValueKey('type_dropdown'),
                onChanged: _handleTypeDropDownChange,
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
            ),
            const SizedBox(height: 16.0),
            InputTitle(title: 'Amount:'),
            const SizedBox(height: 12.0),
            TextFormField(
              key: ValueKey('trans_amount'),
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
            SizedBox(
              width: size.width * 0.9,
              child: DropdownButtonFormField<int>(
                key: ValueKey('categories_dropdown'),
                onChanged: (cat) => setState(() => _categoryDropdownValue = cat ?? -1),
                value: _categoryDropdownValue,
                onSaved: (cat) => _categoryDropdownValue = cat ?? -1,
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
                items: _categories
                    .map((cat) => DropdownMenuItem<int>(
                          key: ValueKey('cat_${cat.categoryID}'),
                          value: cat.categoryID,
                          child: Text(cat.name),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 16.0),
            InputTitle(title: 'Account:'),
            const SizedBox(height: 12.0),
            SizedBox(
              width: size.width * 0.9,
              child: DropdownButtonFormField<int>(
                key: ValueKey('account_dropdown'),
                onChanged: (cat) => setState(() => _accountDropdownValue = cat ?? -1),
                value: _accountDropdownValue,
                onSaved: (cat) => _accountDropdownValue = cat ?? -1,
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
                items: _accounts
                    .map((cat) => DropdownMenuItem<int>(
                          key: ValueKey('acc_${cat.accountID}'),
                          value: cat.accountID,
                          child: Text("${cat.bankName} (${cat.accountNumber})"),
                        ))
                    .toList(),
              ),
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
                  key: ValueKey('date_picker'),
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
              key: ValueKey('description'),
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
                  if (provider.status == TransactionStatus.LOADING || provider.status == TransactionStatus.UPDATING)
                    return Center(child: CircularProgressIndicator(key: ValueKey('progress')));
                  else if (provider.status == TransactionStatus.ERROR)
                    return ErrorWidget(provider.error);
                  else if (provider.status == TransactionStatus.ADDED || provider.status == TransactionStatus.UPDATED)
                    return _onAddComplete(child!);
                  else
                    return child!;
                },
                child: PrimaryButton(key: ValueKey('save'), btnText: 'Save', onPressed: _save),
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

    final bool result = _validateInputs(_title, _transactionType, _amount, _description, _categoryDropdownValue);

    if (!result) return;

    // call onSubmit
    final _selectedCategory = _categories.firstWhere((cat) => cat.categoryID == _categoryDropdownValue);
    final _selectedAccount = _accounts.firstWhere((acc) => acc.accountID == _accountDropdownValue);
    widget.onSubmit(
      widget.isUpdateState ? widget.transaction!.transactionID : '',
      _title,
      _transactionType,
      _amount,
      _categoryDropdownValue,
      _accountDropdownValue,
      _transactionDate,
      _description,
      _selectedCategory.icon,
      _selectedCategory.color,
      _selectedAccount.bankName,
      _selectedAccount.accountNumber,
    );
  }

  bool _validateInputs(String? title, TransactionType? type, double? amount, String? description, int category) {
    if (title == null || title.isEmpty) return false;
    if (type == null) return false;
    if (amount == null || amount <= 0.0) return false;
    if (description == null) return false;
    if (category <= 0) return false;

    return true;
  }

  Widget _onAddComplete(Widget child) {
    // _clearInputs();
    // if (!widget.isUpdateState) {
    context.read<TransactionProvider>().getRecentTransactions().then((_) {
      context.read<TransactionProvider>().getDailySummary();
    });
    // }

    return child;
  }

  void _handleTypeDropDownChange(String? type) {
    setState(() => _typeDropdownValue = type ?? 'EXPENSE');

    final transactionType = Converters.convertTransactionTypeString(_typeDropdownValue);
    context.read<TransactionProvider>().getCategories(transactionType).then((cat) {
      _categoryDropdownValue = cat.first.categoryID;
      setState(() => _categories = cat);
    });
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
}

class InputTitle extends StatelessWidget {
  final String title;

  const InputTitle({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(title, style: FiscalTheme.screenTitleText.copyWith(fontSize: 18.0));
  }
}
