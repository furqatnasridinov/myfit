import 'package:activity/application/notes/notes_notifer.dart';
import 'package:activity/application/notes/notes_state.dart';
import 'package:activity/domain/di/dependency_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final notesProvider =
    StateNotifierProvider<NotesNotifier, NotesState>((ref) => NotesNotifier(scheduleRepo));
