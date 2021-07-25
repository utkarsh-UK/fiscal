import 'package:fiscal/core/utils/routing/navigation_service.dart';
import 'package:fiscal/data/datasources/local/transaction_local_data_source.dart';
import 'package:fiscal/data/datasources/remote/transaction_remote_data_source.dart';
import 'package:fiscal/data/db/database.dart';
import 'package:fiscal/data/repositories/transaction_repository_impl.dart';
import 'package:fiscal/domain/repositories/repositories.dart';
import 'package:fiscal/domain/usecases/core/get_categories.dart';
import 'package:fiscal/domain/usecases/usecases.dart';
import 'package:fiscal/presentation/provider/transaction_provider.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';

final locator = GetIt.instance;

Future<void> init() async {
  // providers
  locator.registerLazySingleton<TransactionProvider>(
    () => TransactionProvider(
      getAllTransactions: locator(),
      getRecentTransactions: locator(),
      addNewTransaction: locator(),
      getDailySummary: locator(),
      getCategories: locator(),
      deleteTransaction: locator(),
    ),
  );

  // usecases
  locator.registerFactory(() => GetAllTransactions(locator()));
  locator.registerFactory(() => GetRecentTransactions(locator()));
  locator.registerFactory(() => AddNewTransaction(locator()));
  locator.registerFactory(() => GetDailySummary(locator()));
  locator.registerFactory(() => GetCategories(locator()));
  locator.registerFactory(() => DeleteTransaction(locator()));

  // repository
  locator.registerFactory<TransactionRepository>(
    () => TransactionRepositoryImpl(
      remoteDataSource: locator(),
      localDataSource: locator(),
    ),
  );

  // data sources
  locator.registerFactory<TransactionRemoteDataSource>(
      () => TransactionRemoteDataSourceImpl(db: locator()));
  locator.registerFactory<TransactionLocalDataSource>(
      () => TransactionLocalDataSourceImpl(locator()));

  //external
  final sharedPreferences = await SharedPreferences.getInstance();
  locator.registerLazySingleton(() => sharedPreferences);

  final db = await FiscalDatabase.instance.database;
  locator.registerSingleton<Database>(db);

  // navigation
  locator.registerLazySingleton(() => NavigationService());
}
