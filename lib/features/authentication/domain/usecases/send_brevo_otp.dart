import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class SendBrevoOtp implements UseCase<String, SendBrevoOtpParams> {
  final AuthRepository repository;

  SendBrevoOtp(this.repository);

  @override
  Future<Either<Failure, String>> call(SendBrevoOtpParams params) async {
    return await repository.sendBrevoOtp(
      phoneNumber: params.phoneNumber,
      method: params.method,
    );
  }
}

class SendBrevoOtpParams extends Equatable {
  final String phoneNumber;
  final String method;

  const SendBrevoOtpParams({
    required this.phoneNumber,
    this.method = 'sms',
  });

  @override
  List<Object?> get props => [phoneNumber, method];
}
