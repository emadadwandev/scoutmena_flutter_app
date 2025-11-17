import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class RegisterWithBrevoOtp implements UseCase<UserEntity, RegisterWithBrevoOtpParams> {
  final AuthRepository repository;

  RegisterWithBrevoOtp(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterWithBrevoOtpParams params) async {
    return await repository.registerWithBrevoOtp(
      verificationId: params.verificationId,
      userData: params.userData,
    );
  }
}

class RegisterWithBrevoOtpParams extends Equatable {
  final String verificationId;
  final Map<String, dynamic> userData;

  const RegisterWithBrevoOtpParams({
    required this.verificationId,
    required this.userData,
  });

  @override
  List<Object?> get props => [verificationId, userData];
}
