import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:par_impar_game/core_services/api_client.dart';
import 'package:par_impar_game/core_services/data_models/participant.dart';

part 'play_manager_state.dart';

class PlayManagerCubit extends Cubit<PlayManagerState> {
  final ApiClient _apiClient;

  PlayManagerCubit(this._apiClient, Participant initialPlayer)
    : super(
        PlayManagerState(
          currentPlayer: initialPlayer,
          status: PlayStatus.initial,
        ),
      ) {
    loadGameData();
  }

  Future<void> loadGameData() async {
    emit(state.copyWith(status: PlayStatus.loading));
    try {
      final updatedPlayer = await _apiClient.getParticipantScore(
        state.currentPlayer!.idName,
      );
      final allPlayers = await _apiClient.getAllParticipants();
      final rivals = allPlayers
          .where((p) => p.idName != state.currentPlayer!.idName)
          .toList();

      Participant? currentSelectedRival = state.selectedRival;
      if (currentSelectedRival != null) {
        bool rivalStillExists = rivals.any(
          (r) => r.idName == currentSelectedRival!.idName,
        );
        if (!rivalStillExists) {
          currentSelectedRival = null;
        }
      }

      emit(
        state.copyWith(
          status: PlayStatus.success,
          currentPlayer: updatedPlayer ?? state.currentPlayer,
          opponents: rivals,
          selectedRival: currentSelectedRival, // Mantém se ainda existir
          clearSelectedRival:
              currentSelectedRival == null, // Limpa se não existir mais
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PlayStatus.failure,
          errorMessage: 'Erro ao carregar dados do jogo.',
        ),
      );
    }
  }

  void pickRival(Participant rival) {
    emit(state.copyWith(selectedRival: rival));
  }

  Future<void> submitBet(int value, int number, int choice) async {
    if (state.currentPlayer == null) return;
    emit(state.copyWith(status: PlayStatus.betting, clearBetMessage: true));
    try {
      final success = await _apiClient.placeParticipantBet(
        state.currentPlayer!.idName,
        value,
        choice,
        number,
      );
      emit(
        state.copyWith(
          status: PlayStatus.success,
          betMessage: success ? 'Aposta Confirmada!' : 'Falha na Aposta.',
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PlayStatus.failure,
          errorMessage: 'Erro ao apostar.',
        ),
      );
    }
  }

  Future<void> initiateChallenge() async {
    if (state.currentPlayer == null || state.selectedRival == null) return;
    if (state.betMessage == null || !state.betMessage!.contains("Confirmada")) {
      emit(state.copyWith(errorMessage: "Faça uma aposta válida antes."));
      return;
    }

    emit(state.copyWith(status: PlayStatus.playing, clearGameOutcome: true));
    try {
      final result = await _apiClient.startMatch(
        state.currentPlayer!.idName,
        state.selectedRival!.idName,
      );
      String outcomeMsg;
      if (result != null && result.containsKey('vencedor')) {
        final winner = result['vencedor'];
        final loser = result['perdedor'];
        outcomeMsg =
            'Vencedor: ${winner['username']} (${winner['parimpar'] == 2 ? "P" : "I"}, #${winner['numero']})\n'
            'Perdedor: ${loser['username']} (${loser['parimpar'] == 2 ? "P" : "I"}, #${loser['numero']})';
      } else {
        outcomeMsg = 'Erro ao determinar o resultado do desafio.';
      }
      await loadGameData(); // Recarrega tudo, incluindo pontos e oponentes
      emit(
        state.copyWith(
          status: PlayStatus.success,
          gameOutcome: outcomeMsg,
          clearBetMessage: true, // Limpa aposta após o jogo
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: PlayStatus.failure,
          errorMessage: 'Erro no desafio.',
        ),
      );
    }
  }

  void clearOutcomeMessage() {
    emit(state.copyWith(clearGameOutcome: true));
  }
}
