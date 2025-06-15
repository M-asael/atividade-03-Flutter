import 'package:par_impar_game/core_services/api_client.dart';
import 'package:par_impar_game/core_services/data_models/participant.dart';
import 'package:par_impar_game/game_features/auth_feature/manager/auth_manager_cubit.dart';
import 'package:par_impar_game/game_features/play_feature/manager/play_manager_cubit.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.instance;

void initializeDependencies() {
  // Services
  injector.registerLazySingleton<ApiClient>(() => ApiClient());

  // Cubits (Factories, as they might depend on runtime data or be recreated per screen)
  injector.registerFactory<AuthManagerCubit>(
    () => AuthManagerCubit(injector<ApiClient>()),
  );

  injector.registerFactoryParam<PlayManagerCubit, Participant, void>(
    (initialPlayer, _) =>
        PlayManagerCubit(injector<ApiClient>(), initialPlayer),
  );
}
