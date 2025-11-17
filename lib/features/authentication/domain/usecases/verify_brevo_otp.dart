import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class VerifyBrevoOtp implements UseCase<String, VerifyBrevoOtpParams> {
  final AuthRepository repository;

  VerifyBrevoOtp(this.repository);

  @override
  Future<Either<Failure, String>> call(VerifyBrevoOtpParams params) async {
    return await repository.verifyBrevoOtp(
      verificationId: params.verificationId,
      otp: params.otp,
    );
  }
}

class VerifyBrevoOtpParams extends Equatable {
  final String verificationId;
  final String otp;

  const VerifyBrevoOtpParams({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [verificationId, otp];
}
