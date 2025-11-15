import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/saved_search.dart';
import '../repositories/scout_repository.dart';

@lazySingleton
class GetSavedSearches implements UseCase<List<SavedSearch>, GetSavedSearchesParams> {
  final ScoutRepository _repository;

  GetSavedSearches(this._repository);

  @override
  Future<Either<Failure, List<SavedSearch>>> call(GetSavedSearchesParams params) async {
    return await _repository.getSavedSearches(params.scoutId);
  }
}

class GetSavedSearchesParams extends Equatable {
  final String scoutId;

  const GetSavedSearchesParams({required this.scoutId});

  @override
  List<Object?> get props => [scoutId];
}
