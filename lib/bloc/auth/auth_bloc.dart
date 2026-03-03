import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';
import '../../services/firebase_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FirebaseService _firebaseService;

  AuthBloc(this._firebaseService) : super(AuthInitial()) {
    on<AuthStarted>(_onAuthStarted);
    on<AuthenticatedUser>(_onAuthenticatedUser);
    on<UnauthenticatedUser>(_onUnauthenticatedUser);
    on<LoginRequested>(_onLoginRequested);
    on<RegisterRequested>(_onRegisterRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<PasswordResetRequested>(_onPasswordResetRequested);
  }

  Future<void> _onAuthStarted(AuthStarted event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.initialize();

      final current = _firebaseService.currentUser;
      if (current != null) {
        emit(Authenticated(current));
      } else {
        emit(Unauthenticated());
      }

      _firebaseService.authStateChanges.listen((user) {
        if (user != null) {
          add(AuthenticatedUser(user));
        } else {
          add(UnauthenticatedUser());
        }
      });
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthenticatedUser(AuthenticatedUser event, Emitter<AuthState> emit) {
    emit(Authenticated(event.user));
  }

  void _onUnauthenticatedUser(UnauthenticatedUser event, Emitter<AuthState> emit) {
    emit(Unauthenticated());
  }

  Future<void> _onLoginRequested(LoginRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.signInWithEmailAndPassword(
        event.email,
        event.password,
      ).timeout(const Duration(seconds: 60));
      emit(Authenticated(_firebaseService.currentUser!));
    } on TimeoutException {
      emit(const AuthFailure('Login timed out. Please check your connection and try again.'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onRegisterRequested(RegisterRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.createUserWithEmailAndPassword(
        event.email,
        event.password,
      ).timeout(const Duration(seconds: 60));
      emit(Authenticated(_firebaseService.currentUser!));
    } on TimeoutException {
      emit(const AuthFailure('Sign up timed out. Please check your connection and try again.'));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onLogoutRequested(LogoutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.signOut();
      emit(Unauthenticated());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onPasswordResetRequested(PasswordResetRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      await _firebaseService.resetPassword(event.email);
      emit(PasswordResetSuccess());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
}
