part of 'play_manager_cubit.dart';

enum PlayStatus { initial, loading, success, failure, betting, playing }

class PlayManagerState extends Equatable {
  final PlayStatus status;
  final Participant? currentPlayer;
  final List<Participant> opponents;
  final Participant? selectedRival;
  final String? betMessage;
  final String? gameOutcome;
  final String? errorMessage;

  const PlayManagerState({
    this.status = PlayStatus.initial,
    this.currentPlayer,
    this.opponents = const [],
    this.selectedRival,
    this.betMessage,
    this.gameOutcome,
    this.errorMessage,
  });

  PlayManagerState copyWith({
    PlayStatus? status,
    Participant? currentPlayer,
    List<Participant>? opponents,
    Participant? selectedRival,
    bool clearSelectedRival = false,
    String? betMessage,
    bool clearBetMessage = false,
    String? gameOutcome,
    bool clearGameOutcome = false,
    String? errorMessage,
  }) {
    return PlayManagerState(
      status: status ?? this.status,
      currentPlayer: currentPlayer ?? this.currentPlayer,
      opponents: opponents ?? this.opponents,
      selectedRival: clearSelectedRival
          ? null
          : selectedRival ?? this.selectedRival,
      betMessage: clearBetMessage ? null : betMessage ?? this.betMessage,
      gameOutcome: clearGameOutcome ? null : gameOutcome ?? this.gameOutcome,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    currentPlayer,
    opponents,
    selectedRival,
    betMessage,
    gameOutcome,
    errorMessage,
  ];
}
