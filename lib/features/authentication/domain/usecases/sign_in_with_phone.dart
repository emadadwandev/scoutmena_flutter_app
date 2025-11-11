import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class SignInWithPhone implements UseCase<String, SignInWithPhoneParams> {
  final AuthRepository repository;

  SignInWithPhone(this.repository);

  @override
  Future<Either<Failure, String>> call(SignInWithPhoneParams params) async {
    return await repository.signInWithPhone(params.phoneNumber);
  }
}

class SignInWithPhoneParams extends Equatable {
  final String phoneNumber;

  const SignInWithPhoneParams({required this.phoneNumber});

  @override
  List<Object?> get props => [phoneNumber];
}
