import 'package:dio/dio.dart';
import '../../domain/entities/class_entity.dart';
import '../../domain/datasource/class_datasource.dart';
import '../../domain/entities/saved_asset_entity.dart';

class ClassDataSourceImpl implements ClassDataSource {
  final Dio dio;

  ClassDataSourceImpl(this.dio);

  @override
  Future<List<ClassEntity>> getAllClasses() async {
    final response = await dio.get("");
    final List classes = response.data['data']['classes'];

    return classes
        .map((e) => ClassEntity(
              id: e['_id'],
              title: e['title'],
              description: e['description'],
              type: e['type'],
              teacherId: e['teacher'],
              studentIds: List<String>.from(e['students'] ?? []),
            ))
        .toList();
  }

  @override
  Future<List<ClassEntity>> getClassesByUser(String userId) async {
    final response = await dio.get('/user/$userId');
    final List classes = response.data['data']['classes'];

    return classes
        .map((e) => ClassEntity(
              id: e['_id'],
              title: e['title'],
              description: e['description'],
              type: e['type'],
              teacherId: e['teacher'],
              studentIds: List<String>.from(e['students'] ?? []),
            ))
        .toList();
  }

  @override
  Future<List<ClassEntity>> getEnrolledClassesByUser(String userId) async {
    final response = await dio.get('/user/$userId/enrolled');
    final List classes = response.data['data']['classes'];

    return classes
        .map((e) => ClassEntity(
              id: e['_id'],
              title: e['title'],
              description: e['description'],
              type: e['type'],
              teacherId: e['teacher'],
              studentIds: List<String>.from(e['students'] ?? []),
            ))
        .toList();
  }

  @override
  Future<ClassEntity> getClassById(String id) async {
    final response = await dio.get('/$id');
    final data = response.data['data']['class'];

    return ClassEntity(
      id: data['_id'],
      title: data['title'],
      description: data['description'],
      type: data['type'],
      teacherId:
          data['teacher'] is Map ? data['teacher']['_id'] : data['teacher'],
      studentIds: List<String>.from(data['students'] ?? []),
    );
  }

  @override
  Future<List<SavedAssetEntity>> fetchSavedAssets() async {
    final response = await dio.get('/assets');

    final List assets = response.data['assets'];

    return assets.map((e) {
      return SavedAssetEntity(
        playbackId: e['playbackId'] as String,
        title: e['title']?.toString(),
        createdAt: e['createdAt'].toString(),
        assetId: e['assetId'].toString(),
        duration: (e['duration'] as num).toDouble(),
        status: e['status'].toString(),
      );
    }).toList();
  }

  @override
  Future<List<SavedAssetEntity>> fetchSavedAssetsByClassId(String id) async {
    final response = await dio.get('/assets/$id');

    final List assetsByClassId = response.data['filteredAssets'];

    return assetsByClassId.map((e) {
      return SavedAssetEntity(
        playbackId: e['playbackId'] as String,
        title: e['title']?.toString(),
        createdAt: e['createdAt'].toString(),
        assetId: e['assetId'].toString(),
        duration: (e['duration'] as num).toDouble(),
        status: e['status'].toString(),
      );
    }).toList();
  }
}
