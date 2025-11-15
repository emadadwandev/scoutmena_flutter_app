import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../repositories/scout_repository.dart';

@lazySingleton
class DeleteSavedSearch implements UseCase<void, DeleteSavedSearchParams> {
  final ScoutRepository _repository;

  DeleteSavedSearch(this._repository);

  @override
  Future<Either<Failure, void>> call(DeleteSavedSearchParams params) async {
    return await _repository.deleteSavedSearch(params.searchId);
  }
}

class DeleteSavedSearchParams extends Equatable {
  final String searchId;

  const DeleteSavedSearchParams({required this.searchId});

  @override
  List<Object?> get props => [searchId];
}
