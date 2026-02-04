import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/user.dart';
import '../../data/repositories/auth_repository.dart';
import '../../services/firebase_auth_service.dart';
import '../../services/local_storage_service.dart';

enum AuthStatus { unknown, authenticated, guest, unauthenticated }

class AuthState {
  const AuthState({
    required this.status,
    this.user,
    this.isLoading = false,
    this.errorMessage,
  });

  final AuthStatus status;
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;

  String? get userName => user?.name;
  String? get photoUrl => user?.photoUrl;

  AuthState copyWith({
    AuthStatus? status,
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({
    required LocalStorageService localStorage,
    FirebaseAuthService? firebaseAuthService,
  })  : _localStorage = localStorage,
        _authRepository = AuthRepository(localStorage: localStorage),
        _firebaseAuthService = firebaseAuthService ?? FirebaseAuthService(),
        super(const AuthState(status: AuthStatus.unknown));

  final LocalStorageService _localStorage;
  final AuthRepository _authRepository;
  final FirebaseAuthService _firebaseAuthService;

  void bootstrap() {
    final token = _localStorage.authToken;
    if (token != null && token.isNotEmpty) {
      emit(const AuthState(status: AuthStatus.authenticated));
    } else if (_localStorage.isGuest) {
      emit(const AuthState(status: AuthStatus.guest));
    } else {
      emit(const AuthState(status: AuthStatus.unauthenticated));
    }
  }

  Future<void> markGuest() async {
    await _localStorage.setIsGuest(true);
    await _localStorage.setAuthToken(null);
    emit(const AuthState(status: AuthStatus.guest));
  }

  Future<void> logout() async {
    await _firebaseAuthService.signOut();
    await _localStorage.clear();
    emit(const AuthState(status: AuthStatus.unauthenticated));
  }

  /// Signs in with Google via Firebase, sends user info to backend to create/update
  /// user in MongoDB (no idToken sent). On success, emits [AuthStatus.authenticated].
  Future<void> signInWithGoogle() async {
    emit(state.copyWith(isLoading: true, errorMessage: null));
    try {
      final userInfo =
          await _firebaseAuthService.signInWithGoogleAndGetUserInfo();
      await _localStorage.setIsGuest(false);
      final user = await _authRepository.loginWithGoogleUserInfo(userInfo);
      emit(
        state.copyWith(
          status: AuthStatus.authenticated,
          user: user,
          isLoading: false,
        ),
      );
    } on FirebaseAuthServiceException catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.message,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}

