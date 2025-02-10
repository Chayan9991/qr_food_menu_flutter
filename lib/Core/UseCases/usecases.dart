import 'package:dartz/dartz.dart';
import 'package:self_order_qr_menu/Core/Error/failures.dart';

abstract interface class UseCase<SuccessType, Params>{
Future<Either<Failure, SuccessType>>call (Params params);
}

class NoParams{}