import 'package:equatable/equatable.dart';
import 'package:fiscal/core/utils/static/messages.dart';

abstract class Failure {
  Failure([List properties = const <dynamic>[]]) : super();
}

class DataFailure extends Failure with EquatableMixin {
  final String message;

  DataFailure({this.message = DEFAULT_DATABASE_FAILURE_MESSAGE }) : super([message]);

  @override
  List<Object> get props => [message];
}

class CacheFailure extends Failure with EquatableMixin {
  final String message;

  CacheFailure({this.message = DEFAULT_CACHE_FAILURE_MESSAGE}) : super([message]);

  @override
  List<Object> get props => [message];
}

class DeviceFailure extends Failure with EquatableMixin {
  final String message;

  DeviceFailure({this.message = DEFAULT_DEVICE_FAILURE_MESSAGE}) : super([message]);

  @override
  List<Object> get props => [message];
}
