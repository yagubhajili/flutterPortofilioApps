import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_person_detail.dart';
import 'person_state.dart';

class PersonCubit extends Cubit<PersonState> {
  final GetPersonDetail getPersonDetail;

  PersonCubit(this.getPersonDetail) : super(PersonInitial());

  Future<void> load(int id) async {
    emit(PersonLoading());
    final result = await getPersonDetail(id);
    result.fold(
      (f) => emit(PersonError(f.message)),
      (person) => emit(PersonLoaded(person)),
    );
  }
}
