import 'package:par_impar_game/app_challenge_setup.dart';
import 'package:par_impar_game/core_services/data_models/participant.dart';
import 'package:par_impar_game/game_features/auth_feature/interface/sign_in_screen.dart';
import 'package:par_impar_game/game_features/play_feature/interface/challenge_arena_screen.dart';
import 'package:flutter/material.dart';

void main() {
  initializeDependencies();
  runApp(const EvenOddChallengeApp());
}

class EvenOddChallengeApp extends StatelessWidget {
  const EvenOddChallengeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EvenOdd Challenge',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.cyanAccent[700],
        scaffoldBackgroundColor: Colors.blueGrey[900],
        colorScheme: ColorScheme.dark(
          primary: Colors.cyanAccent[700]!,
          secondary: Colors.orangeAccent[400]!,
          surface: Colors.blueGrey[800]!,
          background: Colors.blueGrey[900]!,
          error: Colors.redAccent[200]!,
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
          onError: Colors.black,
        ),
        useMaterial3: true,
        fontFamily: 'Orbitron',
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.blueGrey[800],
          elevation: 0,
          titleTextStyle: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent[100],
          ),
          iconTheme: IconThemeData(color: Colors.cyanAccent[100]),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ButtonStyle(
            padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
              const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            shape: WidgetStateProperty.all<OutlinedBorder>(
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
            ),
            textStyle: WidgetStateProperty.all<TextStyle>(
              const TextStyle(
                fontFamily: 'Orbitron',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
      onGenerateRoute: (settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case SignInScreen.routeName:
          case '/':
            builder = (BuildContext _) => const SignInScreen();
            break;
          case ChallengeArenaScreen.routeName:
            final args = settings.arguments as Participant?;
            if (args != null) {
              builder = (BuildContext _) =>
                  ChallengeArenaScreen(authenticatedUser: args);
            } else {
              builder = (BuildContext _) => const SignInScreen();
            }
            break;
          default:
            builder = (BuildContext _) => const SignInScreen();
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
