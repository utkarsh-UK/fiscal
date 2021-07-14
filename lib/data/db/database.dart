import 'package:fiscal/core/core.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class FiscalDatabase {
  static final FiscalDatabase instance = FiscalDatabase._init();

  static Database? _database;

  FiscalDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    final String dbPath = await getDatabasesPath();
    final String path = join(dbPath, 'fiscal.db');

    return await openDatabase(path, onCreate: _createDB, version: 1);
  }

  Future<void> _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final textType = 'TEXT NOT NULL';
    final realType = 'REAL NOT NULL';
    final enumType = "TEXT NOT NULL DEFAULT '${TransactionTable.expense_value}'";
    final typeEnumCheck =
        "CHECK(${TransactionTable.transaction_type} IN ('${TransactionTable.income_value}', '${TransactionTable.expense_value}'))";

    await db.execute('''
          CREATE TABLE ${TransactionTable.TABLE_NAME} ( 
            ${TransactionTable.id} $idType,
            ${TransactionTable.title} $textType CHECK(LENGTH(${TransactionTable.title}) > 0),
            ${TransactionTable.date} $textType,
            ${TransactionTable.description} $textType,
            ${TransactionTable.amount} $realType CHECK(${TransactionTable.amount} > 0),
            ${TransactionTable.transaction_type} $enumType,
            $typeEnumCheck
            );
        ''');
  }

  Future<void> close() async {
    final db = await instance.database;

    return db.close();
  }
}
