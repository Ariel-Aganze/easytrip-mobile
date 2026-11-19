import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/geo/domain/entities/city.dart';
import 'package:easytrip/features/geo/domain/usecases/get_cities.dart';

part 'search_form_state.dart';

/// Loads the list of cities for the origin/destination pickers.
class SearchFormCubit extends Cubit<SearchFormState> {
  SearchFormCubit(this._getCities) : super(const SearchFormState());

  final GetCities _getCities;

  Future<void> loadCities() async {
    emit(state.copyWith(status: LoadStatus.loading, clearError: true));
    final result = await _getCities();
    switch (result) {
      case Ok(value: final cities):
        emit(state.copyWith(status: LoadStatus.ready, cities: cities));
      case Err(failure: final failure):
        emit(state.copyWith(status: LoadStatus.error, errorMessage: failure.message));
    }
  }
}