import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class LoginWithBrevoOtp implements UseCase<UserEntity, LoginWithBrevoOtpParams> {
  final AuthRepository repository;

  LoginWithBrevoOtp(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(LoginWithBrevoOtpParams params) async {
    return await repository.loginWithBrevoOtp(
      verificationId: params.verificationId,
      accountType: params.accountType,
    );
  }
}

class LoginWithBrevoOtpParams extends Equatable {
  final String verificationId;
  final String accountType;

  const LoginWithBrevoOtpParams({
    required this.verificationId,
    required this.accountType,
  });

  @override
  List<Object?> get props => [verificationId, accountType];
}
