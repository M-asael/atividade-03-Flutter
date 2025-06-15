import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:par_impar_game/core_services/data_models/participant.dart';
import 'package:par_impar_game/game_features/play_feature/components/rival_list_widget.dart';
import 'package:par_impar_game/game_features/play_feature/components/wager_panel_widget.dart';
import 'package:par_impar_game/game_features/play_feature/manager/play_manager_cubit.dart';
import 'package:get_it/get_it.dart';

class ChallengeArenaScreen extends StatelessWidget {
  final Participant authenticatedUser;

  const ChallengeArenaScreen({super.key, required this.authenticatedUser});

  static const routeName = '/challenge-arena';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<PlayManagerCubit>(param1: authenticatedUser),
      child: Scaffold(
        backgroundColor: Colors.blueGrey[900],
        appBar: AppBar(
          title: BlocBuilder<PlayManagerCubit, PlayManagerState>(
            builder: (context, state) {
              return Text(
                'Arena: ${state.currentPlayer?.idName ?? authenticatedUser.idName}',
              );
            },
          ),
          backgroundColor: Colors.blueGrey[800],
          elevation: 2,
          actions: [
            BlocBuilder<PlayManagerCubit, PlayManagerState>(
              builder: (context, state) {
                return IconButton(
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  onPressed:
                      (state.status == PlayStatus.loading ||
                          state.status == PlayStatus.betting ||
                          state.status == PlayStatus.playing)
                      ? null
                      : () => context.read<PlayManagerCubit>().loadGameData(),
                );
              },
            ),
          ],
        ),
        body: BlocConsumer<PlayManagerCubit, PlayManagerState>(
          listener: (context, state) {
            if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage!),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
            if (state.gameOutcome != null) {
              showDialog(
                context: context,
                builder: (dialogCtx) => AlertDialog(
                  backgroundColor: Colors.blueGrey[800],
                  title: Text(
                    'Resultado do Desafio',
                    style: TextStyle(color: Colors.cyanAccent[100]),
                  ),
                  content: Text(
                    state.gameOutcome!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  actions: [
                    TextButton(
                      child: Text(
                        'OK',
                        style: TextStyle(color: Colors.cyanAccent[200]),
                      ),
                      onPressed: () {
                        Navigator.of(dialogCtx).pop();
                        context.read<PlayManagerCubit>().clearOutcomeMessage();
                      },
                    ),
                  ],
                ),
              );
            }
          },
          builder: (context, state) {
            if (state.status == PlayStatus.initial ||
                (state.status == PlayStatus.loading &&
                    state.currentPlayer == null)) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.cyanAccent),
              );
            }
            return RefreshIndicator(
              onRefresh: () => context.read<PlayManagerCubit>().loadGameData(),
              color: Colors.cyanAccent,
              backgroundColor: Colors.blueGrey[700],
              child: ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  Card(
                    color: Colors.blueGrey[800],
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16.0,
                        horizontal: 12.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.star_border_purple500_sharp,
                            color: Colors.amberAccent[200],
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'Pontos: ${state.currentPlayer?.score ?? '...'}',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.cyanAccent[100],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const WagerPanelWidget(),
                  const SizedBox(height: 20),
                  const RivalListWidget(),
                  const SizedBox(height: 25),
                  ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(
                          backgroundColor: Colors.greenAccent[700],
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ).copyWith(
                          foregroundColor: WidgetStateProperty.all<Color>(
                            Colors.white,
                          ),
                        ),
                    onPressed:
                        (state.status == PlayStatus.playing ||
                            state.selectedRival == null ||
                            state.betMessage == null ||
                            !state.betMessage!.contains("Confirmada"))
                        ? null
                        : () => context
                              .read<PlayManagerCubit>()
                              .initiateChallenge(),
                    child: (state.status == PlayStatus.playing)
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            'INICIAR DESAFIO!',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
