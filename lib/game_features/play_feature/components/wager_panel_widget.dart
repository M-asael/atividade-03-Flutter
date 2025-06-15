import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:par_impar_game/game_features/play_feature/manager/play_manager_cubit.dart';

class WagerPanelWidget extends StatefulWidget {
  const WagerPanelWidget({super.key});

  @override
  State<WagerPanelWidget> createState() => _WagerPanelWidgetState();
}

class _WagerPanelWidgetState extends State<WagerPanelWidget> {
  final _betValueController = TextEditingController();
  final _numberValueController = TextEditingController();
  int? _choiceValue; // 1 for Odd, 2 for Even

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PlayManagerCubit>();

    return Card(
      elevation: 3,
      color: Colors.blueGrey[800],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Faça sua Jogada',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent[100],
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: _betValueController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Valor da Aposta',
                Icons.account_balance_wallet_outlined,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _numberValueController,
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Número (1-5)',
                Icons.format_list_numbered_rtl_outlined,
              ),
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            ),
            const SizedBox(height: 10),
            DropdownButtonFormField<int>(
              value: _choiceValue,
              dropdownColor: Colors.blueGrey[700],
              style: const TextStyle(color: Colors.white),
              decoration: _inputDecoration(
                'Par ou Ímpar?',
                Icons.help_outline_rounded,
              ).copyWith(prefixIconColor: Colors.cyanAccent[100]),
              items: const [
                DropdownMenuItem(value: 1, child: Text('Ímpar')),
                DropdownMenuItem(value: 2, child: Text('Par')),
              ],
              onChanged: (value) {
                setState(() {
                  _choiceValue = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent[700],
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ).copyWith(
                    foregroundColor: WidgetStateProperty.all<Color>(
                      Colors.white,
                    ),
                  ),
              onPressed: (cubit.state.status == PlayStatus.betting)
                  ? null
                  : () {
                      final betVal = int.tryParse(_betValueController.text);
                      final numVal = int.tryParse(_numberValueController.text);
                      if (betVal != null &&
                          betVal > 0 &&
                          numVal != null &&
                          numVal >= 1 &&
                          numVal <= 5 &&
                          _choiceValue != null) {
                        cubit.submitBet(betVal, numVal, _choiceValue!);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Dados da aposta inválidos!'),
                          ),
                        );
                      }
                    },
              child: (cubit.state.status == PlayStatus.betting)
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Confirmar Jogada',
                      style: TextStyle(fontSize: 16),
                    ),
            ),
            if (cubit.state.betMessage != null) ...[
              const SizedBox(height: 10),
              Text(
                cubit.state.betMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: cubit.state.betMessage!.contains("Confirmada")
                      ? Colors.greenAccent[400]
                      : Colors.redAccent[200],
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(color: Colors.grey[400]),
      prefixIcon: Icon(icon, color: Colors.cyanAccent[100]),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey[700]!),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.cyanAccent[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent[100]!),
        borderRadius: BorderRadius.circular(8),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.redAccent[200]!),
        borderRadius: BorderRadius.circular(8),
      ),
    );
  }
}
