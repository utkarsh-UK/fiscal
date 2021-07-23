import 'package:equatable/equatable.dart';
import 'package:fiscal/core/utils/static/enums.dart';

class Category extends Equatable {
  final int categoryID;
  final String name;
  final String icon;
  final String color;
  final DateTime? createdAt;
  final TransactionType transactionType;

  Category({
    required this.categoryID,
    required this.name,
    required this.icon,
    required this.color,
    this.createdAt,
    this.transactionType = TransactionType.EXPENSE,
  });

  @override
  List<Object> get props => [categoryID, name, icon, color, transactionType];
}
