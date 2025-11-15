import 'package:equatable/equatable.dart';
import 'dart:io';

/// Base class for scout profile events
abstract class ScoutProfileEvent extends Equatable {
  const ScoutProfileEvent();

  @override
  List<Object?> get props => [];
}

// ============================================================================
// Scout Profile Events
// ============================================================================

/// Load scout profile
class LoadScoutProfile extends ScoutProfileEvent {
  final String scoutId;

  const LoadScoutProfile({required this.scoutId});

  @override
  List<Object?> get props => [scoutId];
}

/// Create scout profile
class CreateScoutProfile extends ScoutProfileEvent {
  final Map<String, dynamic> profileData;

  const CreateScoutProfile({required this.profileData});

  @override
  List<Object?> get props => [profileData];
}

/// Update scout profile
class UpdateScoutProfile extends ScoutProfileEvent {
  final String scoutId;
  final Map<String, dynamic> profileData;

  const UpdateScoutProfile({
    required this.scoutId,
    required this.profileData,
  });

  @override
  List<Object?> get props => [scoutId, profileData];
}

/// Upload verification document
class UploadVerificationDocument extends ScoutProfileEvent {
  final File document;

  const UploadVerificationDocument({required this.document});

  @override
  List<Object?> get props => [document];
}
