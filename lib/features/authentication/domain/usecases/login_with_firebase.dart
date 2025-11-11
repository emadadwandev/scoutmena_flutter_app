import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class LoginWithFirebase implements UseCase<UserEntity, NoParams> {
  final AuthRepository repository;

  LoginWithFirebase(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(NoParams params) async {
    return await repository.loginWithFirebase();
  }
}
