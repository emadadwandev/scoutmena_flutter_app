import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class VerifyOTP implements UseCase<firebase_auth.User, VerifyOTPParams> {
  final AuthRepository repository;

  VerifyOTP(this.repository);

  @override
  Future<Either<Failure, firebase_auth.User>> call(VerifyOTPParams params) async {
    return await repository.verifyOTP(
      verificationId: params.verificationId,
      otp: params.otp,
    );
  }
}

class VerifyOTPParams extends Equatable {
  final String verificationId;
  final String otp;

  const VerifyOTPParams({
    required this.verificationId,
    required this.otp,
  });

  @override
  List<Object?> get props => [verificationId, otp];
}
