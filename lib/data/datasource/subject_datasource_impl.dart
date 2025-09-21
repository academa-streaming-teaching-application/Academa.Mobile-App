import 'dart:convert';
import 'package:academa_streaming_platform/domain/entities/user_entity.dart';
import 'package:dio/dio.dart';
import '../../domain/entities/subject_entity.dart';
import '../../domain/datasource/subject_datasource.dart';

class SubjectDataSourceImpl implements SubjectDataSource {
  final Dio dio;
  final String basePath;

  SubjectDataSourceImpl(this.dio, {this.basePath = '/api/v1/subjects'});

  @override
  Future<List<SubjectEntity>> getAllSubjects() async {
    try {
      final Response resp = await dio.get(basePath);
      final Map<String, dynamic> root = Map<String, dynamic>.from(resp.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(root['data']);
      final List<dynamic> rawList = List<dynamic>.from(data['subjects']);

      return rawList
          .map((e) => _mapSubject(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e, st) {
      _logDioError('GET $basePath', e, st);
      throw Exception(_formatDioMessage('GET $basePath', e));
    } catch (e, st) {
      _logGenericError('GET $basePath', e, st);
      throw Exception('Error parseando respuesta de $basePath: $e');
    }
  }

  @override
  Future<List<SubjectEntity>> getTopRatedSubjects({
    int limit = 10,
    int minRatings = 3,
    String? query,
    String? topic,
    String? professorId,
  }) async {
    final String url = '$basePath/top-rated-classes';
    final qp = <String, dynamic>{
      'limit': limit,
      'minRatings': minRatings,
      if (query != null && query.isNotEmpty) 'q': query,
      if (topic != null && topic.isNotEmpty) 'topic': topic,
      if (professorId != null && professorId.isNotEmpty)
        'professor': professorId,
    };

    try {
      final Response resp = await dio.get(url, queryParameters: qp);
      final Map<String, dynamic> root = Map<String, dynamic>.from(resp.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(root['data']);
      final List<dynamic> rawList = List<dynamic>.from(data['subjects']);

      return rawList
          .map((e) => _mapSubject(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e, st) {
      _logDioError('GET $url', e, st, queryParameters: qp);
      throw Exception(_formatDioMessage('GET $url', e));
    } catch (e, st) {
      _logGenericError('GET $url', e, st);
      throw Exception('Error parseando respuesta de $url: $e');
    }
  }

  @override
  Future<SubjectEntity> getSubjectById(String id) async {
    final String url = '$basePath/$id';
    try {
      final Response resp = await dio.get(url);
      final Map<String, dynamic> root = Map<String, dynamic>.from(resp.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(root['data']);
      final Map<String, dynamic> raw =
          Map<String, dynamic>.from(data['subject']);
      return _mapSubject(raw);
    } on DioException catch (e, st) {
      _logDioError('GET $url', e, st);
      throw Exception(_formatDioMessage('GET $url', e));
    } catch (e, st) {
      _logGenericError('GET $url', e, st);
      throw Exception('Error parseando respuesta de $url: $e');
    }
  }

  @override
  Future<bool> follow(
    String subjectId, {
    required String userId,
    required bool follow,
  }) async {
    final String url = '$basePath/follow/$subjectId';
    final body = {'userId': userId, 'follow': follow};

    try {
      await dio.patch(url, data: body);
      return follow;
    } on DioException catch (e, st) {
      _logDioError('PATCH $url', e, st, body: body);
      throw Exception(_formatDioMessage('PATCH $url', e));
    } catch (e, st) {
      _logGenericError('PATCH $url', e, st);
      throw Exception('Error ejecutando PATCH $url: $e');
    }
  }

  // ---------- Mapper ----------
  SubjectEntity _mapSubject(
    Map<String, dynamic> e, {
    String? currentUserId,
  }) {
    UserEntity? _mapProfessor(dynamic raw) {
      if (raw is Map) {
        final m = Map<String, dynamic>.from(raw);
        return UserEntity(
          id: (m['_id'] ?? m['id'] ?? '').toString(),
          name: (m['name'] ?? '').toString(),
          lastName: (m['lastName'] ?? '').toString(),
          email: (m['email'] ?? '')
              .toString(), // ⚠️ asegúrate que el back lo incluya
          image: (m['image'] ?? '').toString(),
          role: (m['role'] ?? '').toString(),
        );
      }
      return null; // si solo viene el ObjectId, no hay datos para el UI
    }

    final List<String> students = (e['students'] is List)
        ? List<String>.from((e['students'] as List).map((x) => '$x'))
        : const <String>[];

    final bool isFollowed = (currentUserId != null)
        ? students.contains(currentUserId)
        : (e['isFollowed'] as bool?) ?? false;

    return SubjectEntity(
      id: (e['_id'] ?? e['id'] ?? '').toString(),
      subject: (e['subject'] ?? '').toString(),
      category: (e['category'] ?? '').toString(),
      description: (e['description'] ?? '').toString(),
      numberOfClasses: (e['numberOfClasses'] as num?)?.toInt() ?? 0,
      averageRating: (e['averageRating'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (e['ratingCount'] as num?)?.toInt() ?? 0,
      professor: _mapProfessor(e['professor']),
      studentIds: students,
      isFollowed: isFollowed,
    );
  }

  // ---------- Helpers de logging ----------
  void _logDioError(String label, DioException e, StackTrace st,
      {Map<String, dynamic>? queryParameters, Object? body}) {
    final status = e.response?.statusCode;
    final method = e.requestOptions.method;
    final path = e.requestOptions.path;
    final qp = queryParameters ?? e.requestOptions.queryParameters;
    final data = e.response?.data;
    final preview = _previewJson(data);
    print('❌ DioError [$label] ($method $path) status=$status');
    if (qp != null && qp.isNotEmpty) print('   ↳ query: $qp');
    if (body != null) print('   ↳ body: $body');
    print('   ↳ message: ${e.message}');
    if (preview != null) print('   ↳ response: $preview');
  }

  void _logGenericError(String label, Object e, StackTrace st) {
    print('❌ Error [$label]: $e');
  }

  String? _previewJson(dynamic data, {int max = 400}) {
    if (data == null) return null;
    try {
      final s = data is String
          ? data
          : const JsonEncoder.withIndent('  ').convert(data);
      return (s.length <= max) ? s : (s.substring(0, max) + '…');
    } catch (_) {
      final s = data.toString();
      return (s.length <= max) ? s : (s.substring(0, max) + '…');
    }
  }

  String _formatDioMessage(String label, DioException e) {
    final sc = e.response?.statusCode;
    final reason = e.response?.statusMessage ?? e.message ?? 'DioException';
    return '$label falló (status=$sc): $reason';
  }

  @override
  Future<void> subscribeToSubject(String subjectId) async {
    final String url = '$basePath/$subjectId/subscribe';
    try {
      await dio.post(url);
    } on DioException catch (e, st) {
      _logDioError('POST $url', e, st);
      throw Exception(_formatDioMessage('POST $url', e));
    } catch (e, st) {
      _logGenericError('POST $url', e, st);
      throw Exception('Error subscribing to subject: $e');
    }
  }

  @override
  Future<void> unsubscribeFromSubject(String subjectId) async {
    final String url = '$basePath/$subjectId/subscribe';
    try {
      await dio.delete(url);
    } on DioException catch (e, st) {
      _logDioError('DELETE $url', e, st);
      throw Exception(_formatDioMessage('DELETE $url', e));
    } catch (e, st) {
      _logGenericError('DELETE $url', e, st);
      throw Exception('Error unsubscribing from subject: $e');
    }
  }

  @override
  Future<bool> getSubscriptionStatus(String subjectId) async {
    final String url = '$basePath/$subjectId/subscription-status';
    try {
      final Response resp = await dio.get(url);
      final Map<String, dynamic> root = Map<String, dynamic>.from(resp.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(root['data']);
      return data['isSubscribed'] as bool? ?? false;
    } on DioException catch (e, st) {
      _logDioError('GET $url', e, st);
      throw Exception(_formatDioMessage('GET $url', e));
    } catch (e, st) {
      _logGenericError('GET $url', e, st);
      throw Exception('Error checking subscription status: $e');
    }
  }

  @override
  Future<List<SubjectEntity>> getFollowedSubjects() async {
    const String url = '/api/v1/users/me/subjects';
    try {
      final Response resp = await dio.get(url);
      final Map<String, dynamic> root = Map<String, dynamic>.from(resp.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(root['data']);
      final List<dynamic> rawList = List<dynamic>.from(data['subjects']);

      return rawList
          .map((e) => _mapSubject(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e, st) {
      _logDioError('GET $url', e, st);
      throw Exception(_formatDioMessage('GET $url', e));
    } catch (e, st) {
      _logGenericError('GET $url', e, st);
      throw Exception('Error fetching followed subjects: $e');
    }
  }

  @override
  Future<List<SubjectEntity>> getTeachingSubjects() async {
    const String url = '/api/v1/users/me/teaching-subjects';
    try {
      final Response resp = await dio.get(url);
      final Map<String, dynamic> root = Map<String, dynamic>.from(resp.data);
      final Map<String, dynamic> data = Map<String, dynamic>.from(root['data']);
      final List<dynamic> rawList = List<dynamic>.from(data['subjects']);

      return rawList
          .map((e) => _mapSubject(Map<String, dynamic>.from(e)))
          .toList();
    } on DioException catch (e, st) {
      _logDioError('GET $url', e, st);
      throw Exception(_formatDioMessage('GET $url', e));
    } catch (e, st) {
      _logGenericError('GET $url', e, st);
      throw Exception('Error fetching teaching subjects: $e');
    }
  }
}
