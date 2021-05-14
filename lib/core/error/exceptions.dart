import 'package:fiscal/core/utils/static/messages.dart';

class DataException implements Exception {
  final String message;
  final int code;

  DataException({
    this.message = DEFAULT_DATA_EXCEPTION_MESSAGE,
    this.code = -1,
  });
}

class CacheException implements Exception {
  final String message;

  CacheException({
    this.message = DEFAULT_CACHE_EXCEPTION_MESSAGE,
  });
}

class DeviceException implements Exception {
  final String message;

  DeviceException({
    this.message = DEFAULT_DEVICE_EXCEPTION_MESSAGE,
  });
}
