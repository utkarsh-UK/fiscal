import 'package:fiscal/core/error/failure.dart';

class Utility {
  static String mapFailureToMessage(Failure failure) {
    if (failure is DataFailure)
      return failure.message;
    else if (failure is CacheFailure)
      return failure.message;
    else if (failure is DeviceFailure)
      return failure.message;
    else
      return 'Unexpected error.';
  }
}