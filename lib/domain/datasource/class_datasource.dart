import '../entities/class_entity.dart';
import '../entities/saved_asset_entity.dart';

abstract class ClassDataSource {
  Future<List<ClassEntity>> getAllClasses();
  Future<List<ClassEntity>> getClassesByUser(String userId);
  Future<List<ClassEntity>> getEnrolledClassesByUser(String userId);
  Future<List<SavedAssetEntity>> fetchSavedAssets();
  Future<List<SavedAssetEntity>> fetchSavedAssetsByClassId(String id);
  Future<ClassEntity> getClassById(String id);
}
