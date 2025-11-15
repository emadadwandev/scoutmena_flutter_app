import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import '../../../../core/error/failures.dart';
import '../../../authentication/domain/usecases/usecase.dart';
import '../entities/saved_search.dart';
import '../repositories/scout_repository.dart';

@lazySingleton
class SaveSearch implements UseCase<SavedSearch, SaveSearchParams> {
  final ScoutRepository _repository;

  SaveSearch(this._repository);

  @override
  Future<Either<Failure, SavedSearch>> call(SaveSearchParams params) async {
    return await _repository.createSavedSearch(params.scoutId, params.searchData);
  }
}

class SaveSearchParams extends Equatable {
  final String scoutId;
  final Map<String, dynamic> searchData;

  const SaveSearchParams({required this.scoutId, required this.searchData});

  @override
  List<Object?> get props => [scoutId, searchData];
}
