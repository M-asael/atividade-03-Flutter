import 'package:par_impar_game/game_features/play_feature/interface/challenge_arena_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:par_impar_game/game_features/auth_feature/manager/auth_manager_cubit.dart';
import 'package:get_it/get_it.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900],
      body: BlocProvider(
        create: (context) => GetIt.I<AuthManagerCubit>(),
        child: BlocConsumer<AuthManagerCubit, AuthManagerState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              Navigator.pushReplacementNamed(
                context,
                ChallengeArenaScreen.routeName,
                arguments: state.user,
              );
            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.errorMessage),
                  backgroundColor: Colors.redAccent,
                ),
              );
            }
          },
          builder: (context, state) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Icon(
                      Icons.sports_esports,
                      size: 100,
                      color: Colors.cyanAccent[400],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'EvenOdd Challenge',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.cyanAccent[400],
                      ),
                    ),
                    const SizedBox(height: 40),
                    TextField(
                      controller: _nameController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Nome do Desafiante',
                        labelStyle: TextStyle(color: Colors.grey[400]),
                        hintText: 'Seu nick aqui',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        prefixIcon: Icon(
                          Icons.account_circle,
                          color: Colors.cyanAccent[400],
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[700]!),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.cyanAccent[400]!,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (state is AuthLoading)
                      const Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.cyanAccent,
                          ),
                        ),
                      )
                    else
                      ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(
                              backgroundColor: Colors.cyanAccent[700],
                              padding: const EdgeInsets.symmetric(vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              textStyle: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ).copyWith(
                              foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.blueGrey[900]!,
                              ),
                            ),
                        onPressed: () {
                          if (_nameController.text.trim().isNotEmpty) {
                            context.read<AuthManagerCubit>().signIn(
                              _nameController.text.trim(),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, insira seu nome.'),
                              ),
                            );
                          }
                        },
                        child: const Text('Entrar na Disputa'),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
