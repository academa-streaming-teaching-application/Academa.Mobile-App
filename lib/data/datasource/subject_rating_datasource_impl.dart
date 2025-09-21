import 'package:academa_streaming_platform/domain/datasource/subject_rating_datasource.dart';
import 'package:academa_streaming_platform/domain/entities/subject_rating_entity.dart';
import 'package:academa_streaming_platform/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';

class SubjectRatingDataSourceImpl implements SubjectRatingDataSource {
  final Dio _dio;

  SubjectRatingDataSourceImpl(this._dio);

  @override
  Future<SubjectRatingEntity> rateSubject({
    required String subjectId,
    required int score,
    String? comment,
  }) async {
    try {
      final data = <String, dynamic>{
        'score': score,
      };

      if (comment != null && comment.isNotEmpty) {
        data['comment'] = comment;
      }

      final response = await _dio.post(
        '/api/v1/subjects/$subjectId/rating',
        data: data,
      );

      final body = response.data;
      if (body is Map && body['data'] is Map && body['data']['rating'] is Map) {
        return _mapRating(Map<String, dynamic>.from(body['data']['rating']));
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo calificar la materia: $msg');
    }
  }

  @override
  Future<SubjectRatingsResponseEntity> getSubjectRatings({
    required String subjectId,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      final response = await _dio.get(
        '/api/v1/subjects/$subjectId/ratings',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );

      final body = response.data;
      if (body is Map && body['data'] is Map) {
        final data = Map<String, dynamic>.from(body['data']);

        final ratingsRaw = data['ratings'] as List? ?? [];
        final ratings = ratingsRaw
            .map((e) => _mapRating(Map<String, dynamic>.from(e as Map)))
            .toList();

        final statsRaw = data['stats'] as Map? ?? {};
        final stats = _mapStats(Map<String, dynamic>.from(statsRaw));

        final metaRaw = body['meta'] as Map? ?? {};
        final meta = _mapMeta(Map<String, dynamic>.from(metaRaw));

        return SubjectRatingsResponseEntity(
          ratings: ratings,
          stats: stats,
          meta: meta,
        );
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudieron obtener las calificaciones: $msg');
    }
  }

  @override
  Future<SubjectRatingEntity?> getUserRating(String subjectId) async {
    try {
      final response = await _dio.get('/api/v1/subjects/$subjectId/my-rating');

      final body = response.data;
      if (body is Map && body['data'] is Map) {
        final data = Map<String, dynamic>.from(body['data']);
        final ratingData = data['rating'];

        if (ratingData == null) {
          return null;
        }

        return _mapRating(Map<String, dynamic>.from(ratingData as Map));
      }

      throw Exception('Invalid response format');
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo obtener tu calificación: $msg');
    }
  }

  @override
  Future<void> deleteRating(String subjectId) async {
    try {
      await _dio.delete('/api/v1/subjects/$subjectId/rating');
    } on DioException catch (e) {
      final msg = e.response?.data is Map
          ? (e.response!.data['message'] ?? e.message)
          : e.message;
      throw Exception('No se pudo eliminar la calificación: $msg');
    }
  }

  // Helper methods for mapping
  SubjectRatingEntity _mapRating(Map<String, dynamic> json) {
    UserEntity? student;

    if (json['student'] is Map) {
      final studentData = Map<String, dynamic>.from(json['student'] as Map);
      student = UserEntity(
        id: (studentData['_id'] ?? studentData['id'] ?? '').toString(),
        name: (studentData['name'] ?? '').toString(),
        lastName: (studentData['lastName'] ?? '').toString(),
        email: (studentData['email'] ?? '').toString(),
        image: (studentData['image'] ?? '').toString(),
        role: (studentData['role'] ?? '').toString(),
      );
    }

    return SubjectRatingEntity(
      id: (json['_id'] ?? json['id'] ?? '').toString(),
      subjectId: (json['subject'] ?? '').toString(),
      studentId: json['student'] is String
          ? json['student'].toString()
          : (json['student'] is Map && json['student']['_id'] != null)
              ? json['student']['_id'].toString()
              : '',
      score: (json['score'] as num?)?.toInt() ?? 0,
      comment: json['comment']?.toString(),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ?? DateTime.now(),
      student: student,
    );
  }

  RatingStatsEntity _mapStats(Map<String, dynamic> json) {
    return RatingStatsEntity(
      averageRating: (json['averageRating'] as num?)?.toDouble() ?? 0.0,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
    );
  }

  RatingMetaEntity _mapMeta(Map<String, dynamic> json) {
    return RatingMetaEntity(
      page: (json['page'] as num?)?.toInt() ?? 1,
      limit: (json['limit'] as num?)?.toInt() ?? 10,
      totalRatings: (json['totalRatings'] as num?)?.toInt() ?? 0,
      totalPages: (json['totalPages'] as num?)?.toInt() ?? 1,
    );
  }
}