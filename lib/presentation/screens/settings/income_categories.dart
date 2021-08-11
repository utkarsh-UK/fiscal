import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/entities.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:fiscal/presentation/widgets/core/primary_button.dart';
import 'package:fiscal/presentation/widgets/home/screen_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class IncomeCategories extends StatefulWidget {
  const IncomeCategories({Key? key}) : super(key: key);

  @override
  _IncomeCategoriesState createState() => _IncomeCategoriesState();
}

class _IncomeCategoriesState extends State<IncomeCategories> {
  late TextEditingController _nameController;
  late TextEditingController _iconController;

  late List<Category> _categories;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();
    _iconController = TextEditingController();
    _categories = [];

    context.read<TransactionProvider>().getCategories(TransactionType.INCOME).then((cat) => setState(() => _categories = cat));
  }

  @override
  void dispose() {
    super.dispose();

    _nameController.dispose();
    _iconController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ScreenTitle(key: ValueKey('income_cat_title'), title: 'Income Categories'),
                  SizedBox(height: size.height * 0.03),
                  _categories.isEmpty
                      ? const Text('No Categories')
                      : SizedBox(
                          height: size.height * 0.6,
                          child: GridView.count(
                            key: ValueKey('income_cat_list'),
                            crossAxisCount: 3,
                            mainAxisSpacing: 6.0,
                            crossAxisSpacing: 6.0,
                            physics: BouncingScrollPhysics(),
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            children: _categories
                                .map((cat) => GestureDetector(
                                      onTap: () => _setInputFieldValues(cat.name, cat.icon),
                                      child: Column(
                                        children: [
                                          Container(
                                            width: 45.0,
                                            height: 45.0,
                                            padding: const EdgeInsets.all(8.0),
                                            margin: const EdgeInsets.only(bottom: 8.0),
                                            decoration: BoxDecoration(
                                              color: Color(0xFFFAFAFA),
                                              borderRadius: BorderRadius.circular(10.0),
                                              boxShadow: [
                                                BoxShadow(color: Colors.grey[400]!, blurRadius: 6.0),
                                              ],
                                            ),
                                            child: SvgPicture.asset('${FiscalAssets.ICONS_PATH}${cat.icon}.svg', width: 10.0),
                                          ),
                                          Text(cat.name, style: FiscalTheme.inputText)
                                        ],
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                  TextFormField(
                    key: ValueKey('income_cat_name'),
                    controller: _nameController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
                      ),
                      counterText: '',
                      hintText: 'Category Name',
                      fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FiscalTheme.SECONDARY_COLOR),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.words,
                    style: FiscalTheme.inputSecondaryText,
                    maxLength: 50,
                    // onSaved: (desc) => _description = desc == null ? '' : desc.trim(),
                  ),
                  TextFormField(
                    key: ValueKey('income_cat_icon'),
                    controller: _iconController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(color: FiscalTheme.TEXT_INPUT_BORDER_COLOR),
                      ),
                      counterText: '',
                      hintText: 'Icon Name',
                      fillColor: FiscalTheme.TEXT_INPUT_BACKGROUND_COLOR,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: FiscalTheme.SECONDARY_COLOR),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                    ),
                    keyboardType: TextInputType.text,
                    textCapitalization: TextCapitalization.none,
                    style: FiscalTheme.inputSecondaryText,
                    maxLength: 50,
                    // onSaved: (desc) => _description = desc == null ? '' : desc.trim(),
                  ),
                  const SizedBox(height: 25.0),
                  SizedBox(
                    width: size.width,
                    child: PrimaryButton(
                      key: ValueKey('income_add_cat'),
                      btnText: 'Add Category',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _setInputFieldValues(String catName, String icon) {
    _nameController.text = catName.titleCase;

    setState(() => _iconController.text = icon.toLowerCase());
  }
}
