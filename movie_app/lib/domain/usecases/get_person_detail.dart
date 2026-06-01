import 'package:dartz/dartz.dart';
import '../entities/person_detail.dart';
import '../repositories/movie_repository.dart';
import '../../core/error/failures.dart';

class GetPersonDetail {
  final MovieRepository repository;
  GetPersonDetail(this.repository);
  Future<Either<Failure, PersonDetail>> call(int id) => repository.getPersonDetail(id);
}
