import 'dart:async';

import 'package:bangla_voice_translator/core/errors/failures.dart';

typedef ResultFuture<T> = Future<({T? data, Failure? failure})>;
typedef ResultVoid = ResultFuture<void>;

extension ResultExtension<T> on ({T? data, Failure? failure}) {
  bool get isSuccess => failure == null;
  bool get isFailure => failure != null;

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) {
    if (failure != null) {
      return onFailure(failure!);
    }
    return onSuccess(data as T);
  }
}
