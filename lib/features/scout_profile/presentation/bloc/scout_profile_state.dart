import 'package:equatable/equatable.dart';
import '../../domain/entities/scout_profile.dart';

/// Base class for scout profile states
abstract class ScoutProfileState extends Equatable {
  const ScoutProfileState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ScoutProfileInitial extends ScoutProfileState {}

/// Loading state
class ScoutProfileLoading extends ScoutProfileState {}

/// Scout profile loaded
class ScoutProfileLoaded extends ScoutProfileState {
  final ScoutProfile profile;

  const ScoutProfileLoaded({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Scout profile created
class ScoutProfileCreated extends ScoutProfileState {
  final ScoutProfile profile;

  const ScoutProfileCreated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Scout profile updated
class ScoutProfileUpdated extends ScoutProfileState {
  final ScoutProfile profile;

  const ScoutProfileUpdated({required this.profile});

  @override
  List<Object?> get props => [profile];
}

/// Document uploading
class DocumentUploading extends ScoutProfileState {
  final double? progress;

  const DocumentUploading({this.progress});

  @override
  List<Object?> get props => [progress];
}

/// Document uploaded
class DocumentUploaded extends ScoutProfileState {
  final String documentUrl;

  const DocumentUploaded({required this.documentUrl});

  @override
  List<Object?> get props => [documentUrl];
}

/// Error state
class ScoutProfileError extends ScoutProfileState {
  final String message;

  const ScoutProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}
