import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecases/get_scout_profile.dart';
import '../../domain/usecases/create_scout_profile.dart' as create_usecase;
import '../../domain/usecases/update_scout_profile.dart' as update_usecase;
import 'scout_profile_event.dart';
import 'scout_profile_state.dart';

@injectable
class ScoutProfileBloc extends Bloc<ScoutProfileEvent, ScoutProfileState> {
  final GetScoutProfile _getScoutProfile;
  final create_usecase.CreateScoutProfile _createScoutProfile;
  final update_usecase.UpdateScoutProfile _updateScoutProfile;

  ScoutProfileBloc(
    this._getScoutProfile,
    this._createScoutProfile,
    this._updateScoutProfile,
  ) : super(ScoutProfileInitial()) {
    on<LoadScoutProfile>(_onLoadScoutProfile);
    on<CreateScoutProfile>(_onCreateScoutProfile);
    on<UpdateScoutProfile>(_onUpdateScoutProfile);
  }

  Future<void> _onLoadScoutProfile(
    LoadScoutProfile event,
    Emitter<ScoutProfileState> emit,
  ) async {
    emit(ScoutProfileLoading());

    final result = await _getScoutProfile(
      GetScoutProfileParams(scoutId: event.scoutId),
    );

    result.fold(
      (failure) => emit(ScoutProfileError(message: failure.message)),
      (profile) => emit(ScoutProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onCreateScoutProfile(
    CreateScoutProfile event,
    Emitter<ScoutProfileState> emit,
  ) async {
    emit(ScoutProfileLoading());

    final result = await _createScoutProfile(
      create_usecase.CreateScoutProfileParams(profileData: event.profileData),
    );

    result.fold(
      (failure) => emit(ScoutProfileError(message: failure.message)),
      (profile) => emit(ScoutProfileCreated(profile: profile)),
    );
  }

  Future<void> _onUpdateScoutProfile(
    UpdateScoutProfile event,
    Emitter<ScoutProfileState> emit,
  ) async {
    emit(ScoutProfileLoading());

    final result = await _updateScoutProfile(
      update_usecase.UpdateScoutProfileParams(
        scoutId: event.scoutId,
        profileData: event.profileData,
      ),
    );

    result.fold(
      (failure) => emit(ScoutProfileError(message: failure.message)),
      (profile) => emit(ScoutProfileUpdated(profile: profile)),
    );
  }
}
