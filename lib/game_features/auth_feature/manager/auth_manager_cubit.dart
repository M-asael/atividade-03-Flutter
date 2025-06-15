import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:par_impar_game/core_services/api_client.dart';
import 'package:par_impar_game/core_services/data_models/participant.dart';

part 'auth_manager_state.dart';

class AuthManagerCubit extends Cubit<AuthManagerState> {
  final ApiClient _apiClient;

  AuthManagerCubit(this._apiClient) : super(AuthInitial());

  Future<void> signIn(String participantName) async {
    emit(AuthLoading());
    try {
      final user = await _apiClient.registerOrGetParticipant(participantName);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(
          const AuthFailure('Não foi possível autenticar. Tente novamente.'),
        );
      }
    } catch (e) {
      emit(AuthFailure('Erro de conexão: ${e.toString()}'));
    }
  }
}
