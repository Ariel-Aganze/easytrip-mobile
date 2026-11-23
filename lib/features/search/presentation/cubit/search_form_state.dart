part of 'search_form_cubit.dart';

class SearchFormState extends Equatable {
  const SearchFormState({
    this.status = LoadStatus.idle,
    this.cities = const [],
    this.errorMessage,
  });

  final LoadStatus status;
  final List<City> cities;
  final String? errorMessage;

  SearchFormState copyWith({
    LoadStatus? status,
    List<City>? cities,
    String? errorMessage,
    bool clearError = false,
  }) {
    return SearchFormState(
      status: status ?? this.status,
      cities: cities ?? this.cities,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, cities, errorMessage];
}
