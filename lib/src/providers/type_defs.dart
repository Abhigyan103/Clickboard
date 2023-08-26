import 'package:fpdart/fpdart.dart';

typedef FutureEither<T> = Future<Either<String, T>>;
typedef FutureVoid = FutureEither<void>;
