import '../../domain/datasource/class_datasource.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/entities/saved_asset_entity.dart';
import '../../domain/repositories/class_repository.dart';

class ClassRepositoryImpl implements ClassRepository {
  final ClassDataSource dataSource;

  ClassRepositoryImpl(this.dataSource);

  @override
  Future<List<ClassEntity>> getAllClasses({String? userId}) {
    return dataSource.getAllClasses(userId: userId);
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

  @override
  Future<List<SavedAssetEntity>> getSavedAssets() {
    return dataSource.fetchSavedAssets();
  }

  @override
  Future<List<SavedAssetEntity>> getSavedAssetsByClassId(String id) {
    return dataSource.fetchSavedAssetsByClassId(id);
  }

  @override
  Future<bool> follow(String classId,
      {required String userId, required bool follow}) {
    return dataSource.follow(classId, userId: userId, follow: follow);
  }
}
