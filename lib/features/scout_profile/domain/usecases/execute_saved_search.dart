import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/search_results.dart';
import '../repositories/scout_repository.dart';

@lazySingleton
class ExecuteSavedSearch implements UseCase<SearchResults, ExecuteSavedSearchParams> {
  final ScoutRepository _repository;

  ExecuteSavedSearch(this._repository);

  @override
  Future<Either<Failure, SearchResults>> call(ExecuteSavedSearchParams params) async {
    return await _repository.executeSavedSearch(params.searchId, params.page);
  }
}

class ExecuteSavedSearchParams extends Equatable {
  final String searchId;
  final int page;

  const ExecuteSavedSearchParams({required this.searchId, this.page = 1});

  @override
  List<Object?> get props => [searchId, page];
}
