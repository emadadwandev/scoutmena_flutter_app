import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class LoginWithEmailPassword implements UseCase<UserEntity, LoginWithEmailPasswordParams> {
  final AuthRepository repository;

  LoginWithEmailPassword(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithEmailPasswordParams params) async {
    return await repository.loginWithEmailPassword(
      email: params.email,
      password: params.password,
    );
  }
}

class LoginWithEmailPasswordParams extends Equatable {
  final String email;
  final String password;

  const LoginWithEmailPasswordParams({
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [email, password];
}
