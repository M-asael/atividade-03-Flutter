import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:par_impar_game/game_features/play_feature/manager/play_manager_cubit.dart';

class RivalListWidget extends StatelessWidget {
  const RivalListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PlayManagerCubit, PlayManagerState>(
      builder: (context, state) {
        if (state.status == PlayStatus.loading && state.opponents.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyanAccent),
          );
        }
        if (state.opponents.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Nenhum rival na arena.',
                style: TextStyle(color: Colors.grey[400], fontSize: 16),
              ),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'Escolha seu Rival:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.cyanAccent[100],
                ),
              ),
            ),
            Container(
              height: 250,
              decoration: BoxDecoration(
                color: Colors.blueGrey[800],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blueGrey[700]!),
              ),
              child: ListView.separated(
                itemCount: state.opponents.length,
                separatorBuilder: (context, index) =>
                    Divider(color: Colors.blueGrey[700], height: 1),
                itemBuilder: (context, index) {
                  final rival = state.opponents[index];
                  final isSelected =
                      state.selectedRival?.idName == rival.idName;
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: isSelected
                          ? Colors.cyanAccent[700]
                          : Colors.blueGrey[600],
                      child: Text(
                        rival.idName.substring(0, 1).toUpperCase(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      rival.idName,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    subtitle: Text(
                      'Score: ${rival.score}',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                    trailing: isSelected
                        ? Icon(
                            Icons.check_circle,
                            color: Colors.cyanAccent[400],
                          )
                        : Icon(Icons.radio_button_off, color: Colors.grey[500]),
                    onTap: () {
                      context.read<PlayManagerCubit>().pickRival(rival);
                    },
                    selected: isSelected,
                    selectedTileColor: Colors.blueGrey[700]?.withAlpha(128),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0),
                    ), // Para que o selectedTileColor preencha
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
