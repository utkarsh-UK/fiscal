import 'package:fiscal/core/core.dart';
import 'package:fiscal/core/utils/static/enums.dart';
import 'package:fiscal/domain/enitities/core/category.dart';

class CategoryModel extends Category {
  final int categoryID;
  final String name;
  final String icon;
  final String color;
  final DateTime? createdAt;
  final TransactionType transactionType;

  CategoryModel({
    required this.categoryID,
    required this.name,
    required this.icon,
    required this.color,
    this.createdAt,
    this.transactionType = TransactionType.EXPENSE,
  }) : super(
          categoryID: categoryID,
          name: name,
          icon: icon,
          color: color,
          createdAt: createdAt,
          transactionType: transactionType,
        );

  factory CategoryModel.fromQueryResult(Map<String, Object?> data) {
    return CategoryModel(
      categoryID: int.parse('${data[CategoryTable.id]}'),
      name: '${data[CategoryTable.name]}',
      icon: '${data[CategoryTable.icon]}',
      color: '${data[CategoryTable.color]}',
      transactionType: Converters.convertTransactionTypeString('${data[CategoryTable.transactionType]}'),
      createdAt: DateTime.parse('${data[CategoryTable.createdAt] ?? DateTime.now()}'),
    );
  }

  factory CategoryModel.fromJSON(Map<String, dynamic> data) {
    return CategoryModel(
      categoryID: int.parse('${data[CategoryTable.id]}'),
      name: '${data[CategoryTable.name]}',
      icon: '${data[CategoryTable.icon]}',
      color: '${data[CategoryTable.color]}',
      transactionType: data[CategoryTable.transactionType] == null
          ? TransactionType.EXPENSE
          : Converters.convertTransactionTypeString('${data[CategoryTable.transactionType]}'),
      createdAt: DateTime.parse('${data[CategoryTable.createdAt] ?? DateTime.now()}'),
    );
  }

  factory CategoryModel.fromTransactionQueryResult(Map<String, Object?> data) {
    return CategoryModel(
      categoryID: int.parse('${data[CategoryTable.id]}'),
      name: '',
      icon: data[CategoryTable.icon] == null ? '' : '${data[CategoryTable.icon]}',
      color: data[CategoryTable.color] == null ? '' : '${data[CategoryTable.color]}',
      transactionType: TransactionType.EXPENSE,
      createdAt: DateTime.now(),
    );
  }

  static Map<String, Object?> toQuery(CategoryModel model) => {
        CategoryTable.name: model.name,
        CategoryTable.icon: model.icon,
        CategoryTable.transactionType: Converters.convertTransactionTypeEnum(model.transactionType),
        CategoryTable.color: model.color,
        CategoryTable.createdAt: model.createdAt == null ? DateTime.now().toIso8601String() : model.createdAt!.toIso8601String(),
      };

  static Map<String, dynamic> toJSON(CategoryModel model) => {
        CategoryTable.id: model.categoryID,
        CategoryTable.name: model.name,
        CategoryTable.icon: model.icon,
        CategoryTable.transactionType: Converters.convertTransactionTypeEnum(model.transactionType),
        CategoryTable.color: model.color,
        CategoryTable.createdAt: model.createdAt == null ? DateTime.now().toIso8601String() : model.createdAt!.toIso8601String(),
      };
}
