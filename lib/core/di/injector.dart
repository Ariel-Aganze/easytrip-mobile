import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';

import 'package:easytrip/core/localization/locale_cubit.dart';
import 'package:easytrip/core/network/api_client.dart';
import 'package:easytrip/core/storage/token_storage.dart';
import 'package:easytrip/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:easytrip/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:easytrip/features/auth/domain/repositories/auth_repository.dart';
import 'package:easytrip/features/auth/domain/usecases/check_session.dart';
import 'package:easytrip/features/auth/domain/usecases/get_current_user.dart';
import 'package:easytrip/features/auth/domain/usecases/login_usecase.dart';
import 'package:easytrip/features/auth/domain/usecases/logout_usecase.dart';
import 'package:easytrip/features/auth/domain/usecases/register_usecase.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/features/auth/presentation/cubit/login_cubit.dart';
import 'package:easytrip/features/auth/presentation/cubit/register_cubit.dart';

import 'package:easytrip/features/geo/data/datasources/geo_remote_datasource.dart';
import 'package:easytrip/features/geo/data/repositories/geo_repository_impl.dart';
import 'package:easytrip/features/geo/domain/repositories/geo_repository.dart';
import 'package:easytrip/features/geo/domain/usecases/get_cities.dart';
import 'package:easytrip/features/search/data/datasources/search_remote_datasource.dart';
import 'package:easytrip/features/search/data/repositories/search_repository_impl.dart';
import 'package:easytrip/features/search/domain/repositories/search_repository.dart';
import 'package:easytrip/features/search/domain/usecases/search_trips.dart';
import 'package:easytrip/features/search/presentation/cubit/search_form_cubit.dart';
import 'package:easytrip/features/search/presentation/cubit/search_results_cubit.dart';

import 'package:easytrip/features/trip/data/datasources/trip_remote_datasource.dart';
import 'package:easytrip/features/trip/data/repositories/trip_repository_impl.dart';
import 'package:easytrip/features/trip/domain/repositories/trip_repository.dart';
import 'package:easytrip/features/trip/domain/usecases/get_seat_map.dart';
import 'package:easytrip/features/trip/domain/usecases/get_trip_detail.dart';
import 'package:easytrip/features/trip/presentation/cubit/trip_detail_cubit.dart';

import 'package:easytrip/features/booking/data/datasources/booking_remote_datasource.dart';
import 'package:easytrip/features/booking/data/repositories/booking_repository_impl.dart';
import 'package:easytrip/features/booking/domain/repositories/booking_repository.dart';
import 'package:easytrip/features/booking/domain/usecases/create_booking.dart';
import 'package:easytrip/features/booking/domain/usecases/get_payment.dart';
import 'package:easytrip/features/booking/domain/usecases/initiate_payment.dart';
import 'package:easytrip/features/booking/presentation/cubit/checkout_cubit.dart';
import 'package:easytrip/features/booking/presentation/cubit/payment_status_cubit.dart';

import 'package:easytrip/features/ticket/data/datasources/ticket_remote_datasource.dart';
import 'package:easytrip/features/ticket/data/repositories/ticket_repository_impl.dart';
import 'package:easytrip/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:easytrip/features/ticket/domain/usecases/get_my_tickets.dart';
import 'package:easytrip/features/ticket/presentation/cubit/tickets_cubit.dart';

/// Global service locator. Call [configureDependencies] once in main().
final GetIt sl = GetIt.instance;

Future<void> configureDependencies() async {
  // ---- Core ----
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
    ),
  );
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage(sl()));
  sl.registerLazySingleton<ApiClient>(() => ApiClient(tokenStorage: sl()));
  sl.registerLazySingleton<LocaleCubit>(() => LocaleCubit());

  // ---- Auth: data ----
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remote: sl(), tokenStorage: sl()),
  );

  // ---- Auth: domain (use cases) ----
  sl.registerFactory(() => LoginUseCase(sl()));
  sl.registerFactory(() => RegisterUseCase(sl()));
  sl.registerFactory(() => LogoutUseCase(sl()));
  sl.registerFactory(() => GetCurrentUser(sl()));
  sl.registerFactory(() => CheckSession(sl()));

  // ---- Auth: presentation ----
  sl.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      checkSession: sl(),
      getCurrentUser: sl(),
      logoutUseCase: sl(),
    ),
  );
  sl.registerFactory<LoginCubit>(() => LoginCubit(sl()));
  sl.registerFactory<RegisterCubit>(() => RegisterCubit(sl()));

    // ---- Geo ----
  sl.registerLazySingleton<GeoRemoteDataSource>(
    () => GeoRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<GeoRepository>(() => GeoRepositoryImpl(sl()));
  sl.registerFactory(() => GetCities(sl()));

  // ---- Search ----
  sl.registerLazySingleton<SearchRemoteDataSource>(
    () => SearchRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<SearchRepository>(() => SearchRepositoryImpl(sl()));
  sl.registerFactory(() => SearchTrips(sl()));
  sl.registerFactory<SearchFormCubit>(() => SearchFormCubit(sl()));
  sl.registerFactory<SearchResultsCubit>(() => SearchResultsCubit(sl()));

    // ---- Trip detail ----
  sl.registerLazySingleton<TripRemoteDataSource>(
    () => TripRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<TripRepository>(() => TripRepositoryImpl(sl()));
  sl.registerFactory(() => GetTripDetail(sl()));
  sl.registerFactory(() => GetSeatMap(sl()));
  sl.registerFactoryParam<TripDetailCubit, String, int>(
    (tripId, passengers) => TripDetailCubit(
      getTripDetail: sl(),
      getSeatMap: sl(),
      tripId: tripId,
      passengers: passengers,
    ),
  );

  // ---- Booking + payment ----
  sl.registerLazySingleton<BookingRemoteDataSource>(
    () => BookingRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<BookingRepository>(() => BookingRepositoryImpl(sl()));
  sl.registerFactory(() => CreateBooking(sl()));
  sl.registerFactory(() => InitiatePayment(sl()));
  sl.registerFactory(() => GetPayment(sl()));
  sl.registerFactoryParam<CheckoutCubit, String, void>(
    (tripId, _) => CheckoutCubit(
      createBooking: sl(),
      initiatePayment: sl(),
      tripId: tripId,
    ),
  );
  sl.registerFactoryParam<PaymentStatusCubit, String, void>(
    (paymentId, _) => PaymentStatusCubit(getPayment: sl(), paymentId: paymentId),
  );

    // ---- Tickets ----
  sl.registerLazySingleton<TicketRemoteDataSource>(
    () => TicketRemoteDataSourceImpl(sl<ApiClient>().dio),
  );
  sl.registerLazySingleton<TicketRepository>(() => TicketRepositoryImpl(sl()));
  sl.registerFactory(() => GetMyTickets(sl()));
  sl.registerFactory<TicketsCubit>(() => TicketsCubit(sl()));
}