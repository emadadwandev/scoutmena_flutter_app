import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/search_results.dart';
import '../entities/search_filters.dart';
import '../repositories/scout_repository.dart';

@lazySingleton
class SearchPlayers implements UseCase<SearchResults, SearchPlayersParams> {
  final ScoutRepository _repository;

  SearchPlayers(this._repository);

  @override
  Future<Either<Failure, SearchResults>> call(SearchPlayersParams params) async {
    return await _repository.searchPlayers(params.filters, params.page);
  }
}

class SearchPlayersParams extends Equatable {
  final SearchFilters filters;
  final int page;

  const SearchPlayersParams({required this.filters, this.page = 1});

  @override
  List<Object?> get props => [filters, page];
}
