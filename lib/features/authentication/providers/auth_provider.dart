import 'package:sectec30/config/shared_provider/shared_providers.dart';
import 'package:sectec30/features/authentication/data/api/auth_api.dart';
import 'package:sectec30/features/authentication/data/models/user.dart';
import 'package:sectec30/features/authentication/data/repository/auth_repository.dart';
import 'package:sectec30/utils/key_value_storage_service.dart';
import 'package:sectec30/utils/key_value_storage_service_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authApiProvider = Provider<AuthApi>((ref) {
  return AuthApi(ref.read(dioClientProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(ref.read(authApiProvider));
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final authRepository = ref.read(authRepositoryProvider);
  final keyValueStorageService = KeyValueStorageServiceImpl();

  return AuthNotifier(
      ref: ref,
      authRepository: authRepository,
      keyValueStorageService: keyValueStorageService);
});

final isLoadingSingInProvider = StateProvider<bool>((ref) {
  return false;
});

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final KeyValueStorageService keyValueStorageService;
  final Ref ref;

  AuthNotifier(
      {required this.authRepository,
      required this.keyValueStorageService,
      required this.ref})
      : super(AuthState()) {
    checkAuthStatus();
  }

  Future<void> loginWithQr(String qr) async {
    ref.read(isLoadingSingInProvider.notifier).state = true;

    try {
      final login = await authRepository.loginWithQr(qr);
      _setLoggedUser(login);
      ref.read(isLoadingSingInProvider.notifier).state = false;
    } catch (e) {
      ref.read(isLoadingSingInProvider.notifier).state = false;
      logout(e.toString());
    }
  }

  Future<void> loginWithCredentials(String email, String password) async {
    ref.read(isLoadingSingInProvider.notifier).state = true;

    try {
      final login = await authRepository.loginWithCredentials(email, password);
      _setLoggedUser(login);
      ref.read(isLoadingSingInProvider.notifier).state = false;
    } catch (e) {
      ref.read(isLoadingSingInProvider.notifier).state = false;
      logout(e.toString());
    }
  }

  void checkAuthStatus() async {
    final token = await keyValueStorageService.getValue<String>('token');
    final userId = await keyValueStorageService.getValue<String>('userId');
    final qr = await keyValueStorageService.getValue<String>('qr');
    final curp = await keyValueStorageService.getValue<String>('curp');
    if (token == null || userId == null || qr == null || curp == null) {
      return logout();
    }
    try {
      final login = await authRepository.loginWithQr(qr);
      _setLoggedUser(login);
    } catch (e) {
      logout();
    }
  }

  void _setLoggedUser(User user) async {
    await keyValueStorageService.setKeyValue('token', user.authToken as String);
    await keyValueStorageService.setKeyValue('userId', user.id as String);
    await keyValueStorageService.setKeyValue('qr', user.qr as String);
    await keyValueStorageService.setKeyValue('curp', user.curp as String);

    state = state.copyWith(
      user: user,
      authStatus: AuthStatus.authenticated,
      errorMessage: '',
    );
  }

  Future<void> logout([String? errorMessage]) async {
    await keyValueStorageService.clear();

    state = state.copyWith(
        authStatus: AuthStatus.notAuthenticated,
        user: null,
        errorMessage: errorMessage);
  }
}

enum AuthStatus { checking, authenticated, notAuthenticated }

class AuthState {
  final AuthStatus authStatus;
  final User? user;
  final String errorMessage;

  AuthState(
      {this.authStatus = AuthStatus.checking,
      this.user,
      this.errorMessage = ''});

  AuthState copyWith({
    AuthStatus? authStatus,
    User? user,
    String? errorMessage,
  }) =>
      AuthState(
          authStatus: authStatus ?? this.authStatus,
          user: user ?? this.user,
          errorMessage: errorMessage ?? this.errorMessage);
}
