import '../../domain/datasource/class_datasource.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/repositories/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassDataSource dataSource;

  ClassRepositoryImpl(this.dataSource);

  @override
  Future<List<ClassEntity>> getAllClasses() {
    return dataSource.getAllClasses();
  }

  @override
  Future<List<ClassEntity>> getClassesByUser(String userId) {
    return dataSource.getClassesByUser(userId);
  }

  @override
  Future<List<ClassEntity>> getEnrolledClassesByUser(String userId) {
    return dataSource.getEnrolledClassesByUser(userId);
  }

  @override
  Future<ClassEntity> getClassById(String id) {
    return dataSource.getClassById(id);
  }
}
