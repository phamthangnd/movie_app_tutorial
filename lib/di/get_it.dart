import 'package:get_it/get_it.dart';
import 'package:http/http.dart';
import 'package:movieapp/data/database/records_database.dart';
import 'package:movieapp/data/database/records_database_impl.dart';
import 'package:movieapp/data/repositories/user_repository_impl.dart';
import 'package:movieapp/domain/repositories/user_repository.dart';
import 'package:movieapp/domain/usecases/check_auth.dart';
import 'package:movieapp/domain/usecases/get_account_info.dart';
import 'package:movieapp/presentation/blocs/account/get_account_cubit.dart';
import 'package:movieapp/presentation/blocs/authentication/auth_cubit.dart';
import 'package:movieapp/presentation/blocs/home/home_cubit.dart';
import '../domain/usecases/get_preferred_theme.dart';
import '../domain/usecases/update_theme.dart';
import '../presentation/blocs/theme/theme_cubit.dart';

import '../data/core/api_client.dart';
import '../data/data_sources/authentication_local_data_source.dart';
import '../data/data_sources/authentication_remote_data_source.dart';
import '../data/data_sources/language_local_data_source.dart';
import '../data/data_sources/movie_local_data_source.dart';
import '../data/data_sources/movie_remote_data_source.dart';
import '../data/repositories/app_repository_impl.dart';
import '../data/repositories/authentication_repository_impl.dart';
import '../data/repositories/movie_repository_impl.dart';
import '../domain/repositories/app_repository.dart';
import '../domain/repositories/authentication_repository.dart';
import '../domain/repositories/movie_repository.dart';
import '../domain/usecases/check_if_movie_favorite.dart';
import '../domain/usecases/delete_favorite_movie.dart';
import '../domain/usecases/get_cast.dart';
import '../domain/usecases/get_coming_soon.dart';
import '../domain/usecases/get_favorite_movies.dart';
import '../domain/usecases/get_playing_now.dart';
import '../domain/usecases/get_popular.dart';
import '../domain/usecases/get_preferred_language.dart';
import '../domain/usecases/get_trending.dart';
import '../domain/usecases/get_videos.dart';
import '../domain/usecases/login_user.dart';
import '../domain/usecases/logout_user.dart';
import '../domain/usecases/save_movie.dart';
import '../domain/usecases/update_language.dart';
import '../presentation/blocs/language/language_cubit.dart';
import '../presentation/blocs/loading/loading_cubit.dart';
import '../presentation/blocs/login/login_cubit.dart';
import '../presentation/blocs/movie_backdrop/movie_backdrop_cubit.dart';
import '../presentation/blocs/movie_carousel/movie_carousel_cubit.dart';
import '../presentation/blocs/movie_tabbed/movie_tabbed_cubit.dart';

final getItInstance = GetIt.I;

Future init() async {
  getItInstance.registerLazySingleton<Client>(() => Client());

  getItInstance.registerLazySingleton<ApiClient>(() => ApiClient(getItInstance()));

  getItInstance.registerLazySingleton<RecordsDatabase>(() => RecordsDatabaseImpl());

  getItInstance.registerLazySingleton<MovieRemoteDataSource>(() => MovieRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<MovieLocalDataSource>(() => MovieLocalDataSourceImpl());

  getItInstance.registerLazySingleton<LanguageLocalDataSource>(() => LanguageLocalDataSourceImpl());

  getItInstance.registerLazySingleton<AuthenticationRemoteDataSource>(() => AuthenticationRemoteDataSourceImpl(getItInstance()));

  getItInstance.registerLazySingleton<AuthenticationLocalDataSource>(() => AuthenticationLocalDataSourceImpl());

  getItInstance.registerLazySingleton<CheckAuthUseCase>(() => CheckAuthUseCase(getItInstance()));
  getItInstance.registerLazySingleton<GetTrending>(() => GetTrending(getItInstance()));
  getItInstance.registerLazySingleton<GetPopular>(() => GetPopular(getItInstance()));
  getItInstance.registerLazySingleton<GetPlayingNow>(() => GetPlayingNow(getItInstance()));
  getItInstance.registerLazySingleton<GetComingSoon>(() => GetComingSoon(getItInstance()));

  getItInstance.registerLazySingleton<GetCast>(() => GetCast(getItInstance()));

  getItInstance.registerLazySingleton<GetVideos>(() => GetVideos(getItInstance()));

  getItInstance.registerLazySingleton<SaveMovie>(() => SaveMovie(getItInstance()));

  getItInstance.registerLazySingleton<GetFavoriteMovies>(() => GetFavoriteMovies(getItInstance()));

  getItInstance.registerLazySingleton<DeleteFavoriteMovie>(() => DeleteFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<CheckIfFavoriteMovie>(() => CheckIfFavoriteMovie(getItInstance()));

  getItInstance.registerLazySingleton<UpdateLanguage>(() => UpdateLanguage(getItInstance()));

  getItInstance.registerLazySingleton<GetPreferredLanguage>(() => GetPreferredLanguage(getItInstance()));

  getItInstance.registerLazySingleton<UpdateTheme>(() => UpdateTheme(getItInstance()));

  getItInstance.registerLazySingleton<GetPreferredTheme>(() => GetPreferredTheme(getItInstance()));

  getItInstance.registerLazySingleton<LoginUser>(() => LoginUser(getItInstance()));

  getItInstance.registerLazySingleton<LogoutUser>(() => LogoutUser(getItInstance()));
  getItInstance.registerLazySingleton<GetAccountInfo>(() => GetAccountInfo(getItInstance()));

  getItInstance.registerLazySingleton<MovieRepository>(() => MovieRepositoryImpl(
        getItInstance(),
        getItInstance(),
      ));

  getItInstance.registerLazySingleton<UserRepository>(() => UserRepositoryImpl(
        getItInstance(),
        getItInstance(),
      ));

  getItInstance.registerLazySingleton<AppRepository>(() => AppRepositoryImpl(
        getItInstance(),
      ));

  getItInstance
      .registerLazySingleton<AuthenticationRepository>(() => AuthenticationRepositoryImpl(getItInstance(), getItInstance()));

  getItInstance.registerFactory(() => MovieBackdropCubit());

  getItInstance.registerFactory(() => HomeCubit());
  getItInstance.registerFactory(() => GetAccountCubit(
        getAccountInfo: getItInstance(),
        loadingCubit: getItInstance(),
      ));

  getItInstance.registerFactory(
    () => MovieCarouselCubit(
      loadingCubit: getItInstance(),
      getTrending: getItInstance(),
      movieBackdropCubit: getItInstance(),
    ),
  );

  getItInstance.registerFactory(
    () => MovieTabbedCubit(
      getPopular: getItInstance(),
      getComingSoon: getItInstance(),
      getPlayingNow: getItInstance(),
    ),
  );

  getItInstance.registerSingleton<LanguageCubit>(LanguageCubit(
    updateLanguage: getItInstance(),
    getPreferredLanguage: getItInstance(),
  ));

  getItInstance.registerFactory(() => LoginCubit(
        loginUser: getItInstance(),
        logoutUser: getItInstance(),
        loadingCubit: getItInstance(),
      ));
  getItInstance.registerFactory(() => AuthCubit(
        checkAuth: getItInstance(),
        loadingCubit: getItInstance(),
      ));

  getItInstance.registerSingleton<LoadingCubit>(LoadingCubit());
  getItInstance.registerSingleton<ThemeCubit>(ThemeCubit(
    getPreferredTheme: getItInstance(),
    updateTheme: getItInstance(),
  ));
}
