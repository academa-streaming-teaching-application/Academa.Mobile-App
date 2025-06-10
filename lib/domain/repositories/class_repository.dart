import '../entities/class_entity.dart';
import '../entities/saved_asset_entity.dart';

abstract class ClassRepository {
  Future<List<ClassEntity>> getAllClasses({String? userId});
  Future<List<ClassEntity>> getClassesByUser(String userId);
  Future<List<ClassEntity>> getEnrolledClassesByUser(String userId);
  Future<ClassEntity> getClassById(String id);
  Future<List<SavedAssetEntity>> getSavedAssets();
  Future<List<SavedAssetEntity>> getSavedAssetsByClassId(String id);
  Future<bool> follow(String classId,
      {required String userId, required bool follow});
}
