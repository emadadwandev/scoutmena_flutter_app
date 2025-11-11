import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';
import 'usecase.dart';

class RegisterUser implements UseCase<UserEntity, RegisterUserParams> {
  final AuthRepository repository;

  RegisterUser(this.repository);

  @override
  Future<Either<Failure, UserEntity>> call(RegisterUserParams params) async {
    return await repository.register(
      firebaseUid: params.firebaseUid,
      userData: params.userData,
    );
  }
}

class RegisterUserParams extends Equatable {
  final String firebaseUid;
  final Map<String, dynamic> userData;

  const RegisterUserParams({
    required this.firebaseUid,
    required this.userData,
  });

  @override
  List<Object?> get props => [firebaseUid, userData];
}
